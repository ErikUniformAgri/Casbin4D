// Copyright 2018 by John Kouraklis and Contributors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
unit Casbin.Parser;

interface

uses
  Casbin.Core.Base.Types, Casbin.Parser.Types, Casbin.Core.Logger.Types, Casbin.Parser.AST.Types;

type
  TParser = class (TBaseInterfacedObject, IParser)
  private
    fLogger: ILogger;
    fErrorMessage: string;
    fParseString: string;
    fParseType: TParseType;
    fStatus: TParserStatus;
    fNodes: TNodeCollection;
    procedure cleanWhiteSpace; //PALOFF
    procedure checkSyntaxErrors; //PALOFF
    procedure checkHeaders;  //PALOFF
    procedure parseContent;
  private
{$REGION 'Interface'}
    function getErrorMessage: string;
    function getLogger: ILogger;
    function getParseType: TParseType;
    procedure parse;
    procedure setLogger(const aValue: ILogger);
    function getStatus: TParserStatus;
    function getNodes: TNodeCollection;
{$ENDREGION}
  public
    constructor Create(const aParseString: string; const aParseType: TParseType);
    destructor Destroy; override;
  end;

implementation

uses
  Casbin.Core.Logger.Default, System.IniFiles, System.Classes,
  Casbin.Core.Defaults, Casbin.Core.Strings, System.StrUtils,
  Casbin.Model.Sections.Types,
  Casbin.Model.Sections.Default, Casbin.Parser.AST, Casbin.Effect.Types,
  System.Math, Casbin.Core.Utilities, System.SysUtils;

constructor TParser.Create(const aParseString: string; const aParseType:
    TParseType);
begin
  inherited Create;
  fParseString:=aParseString;
  fParseType:=aParseType;
  fLogger:=TDefaultLogger.Create;
  fStatus:=psIdle;
  fNodes:=TNodeCollection.Create;
end;

destructor TParser.Destroy;
begin
  fNodes.Free;
  inherited;
end;

procedure TParser.checkHeaders;
var
  headerSet: TSectionTypeSet;
  section: TSectionType;
  sectionObj: TSection;
  fileString: string;
begin
  case fParseType of
    ptModel: begin
               headerSet:= modelSections;
               fileString:=modelFileString;
             end;
    ptPolicy: begin
                headerSet:= policySections;
                fileString:=policyFileString;
              end;
    ptConfig: begin
                headerSet:= configSections;
                fileString:=configFileString;
              end;
  end;

  for section in headerSet do
  begin
    sectionObj:=createDefaultSection(section);
    if (Pos(UpperCase(sectionObj.Header), UpperCase(fParseString)) = 0) and
                                              sectionObj.Required then
    begin
      fErrorMessage:=Format(errorSectionNotFound,
                            [sectionObj.Header, fileString]);
      fStatus:=psError;
    end;
    sectionObj.Free;
    if fStatus=psError then
      Exit;
  end;
end;

procedure TParser.checkSyntaxErrors;
var
  insideHeader: Boolean;
  ch: Char;
  fileString: string;
  numLSquare: integer;
  posX: Integer;
  posY: Integer;
  strList: TStringList;
  showError: Boolean;
begin
  case fParseType of
    ptModel: fileString:=modelFileString;
    ptPolicy: fileString:=policyFileString;
    ptConfig: fileString:=configFileString;
  end;

  insideHeader:=False;
  numLSquare:=0;
  posX:=Low(string);
  posY:=1;
  for ch in fParseString do
  begin
    showError:=False;
    case ch of
      '[': if insideHeader then
             showError:=True
           else
           begin
            insideHeader:=True;
            Inc(numLSquare);
           end;
      ']': begin
             insideHeader:=False;
             if numLSquare = 0 then
              showError:=True;
           end;
    end;

    if showError then
    begin
      fErrorMessage:=format(errorWrongHeaderFormat, [PosX, PosY, fileString]);
      fStatus:=psError;
      Exit;
    end;

    if SameText(Copy(fParseString, posX, Length(EOL)), EOL) then
    begin
      posX:=Low(string);
      Inc(posY);
    end
    else
      Inc(posX);
  end;

  // If there is no section in the beginning add the default
  // to keep the parser happy
  strList:=TStringList.Create;
  try
    strList.Text:=fParseString;
    if (strList.Count>0) and (strList.Strings[0][Low(string)]<>'[') then
      fParseString:='['+DefaultSection.Header+']'+EOL+fParseString;
  finally
    strList.Free;
  end;
end;

procedure TParser.cleanWhiteSpace;
var
  index: integer;
  assignmentIndex: integer;
  i: Integer;
  lenPosition: Integer;
  matchersPosEnd: Integer;
  nextSectionPos: Integer;
  section: TSection;
  testStr: string;
begin
  // Clean EOL in front of the string
  while (Length(fParseString)>0) and (Length(fParseString)>=Length(EOL)) and
    (Copy(fParseString, Low(string), Length(EOL)) = EOL) do
    fParseString:=Copy(fParseString, Length(EOL)+1, Length(fParseString));

  // Clean multiline chars
  index:= Pos(DefaultMultilineCharacters, fParseString, Low(string));
  while index<>0 do
  begin
    testStr:=Copy(fParseString, index+Length(DefaultMultilineCharacters),
                                                                  Length(EOL));
    if testStr=EOL then
      Delete(fParseString, index+Length(DefaultMultilineCharacters),
                                                                  Length(EOL));
    Delete(fParseString, index, Length(DefaultMultilineCharacters));
    index:= Pos(DefaultMultilineCharacters, fParseString, Low(string));
  end;

  // Clean tabs
  index:= Pos(#9, fParseString, Low(string));
  while index<>0 do
  begin
    Delete(fParseString, index, 1);
    index:= Pos(#9, fParseString, Low(string));
  end;

  // Clean spaces
  // Except in Config file if spaces are in values
  // Except in Matchers section
  lenPosition:=0;
  index:= Pos(#32, fParseString, Low(string));
  while (index<>0) and (lenPosition<=Length(fParseString)) do
  begin
    if fParseType=ptConfig then
    begin
      assignmentIndex:=Pos(AssignmentCharForConfig, fParseString, Low(string));
      if (assignmentIndex<>0) and (assignmentIndex>index) then
        Delete(fParseString, index, 1)
      else
        Break;
    end
    else
    begin
      section:=createDefaultSection(stMatchers);
      matchersPosEnd:=Pos(UpperCase(section.Header), UpperCase(fParseString),
                                                low(string));
      if matchersPosEnd>0 then
        matchersPosEnd:=matchersPosEnd+Length(section.Header+']');
      section.Free;
      nextSectionPos:=0;
      for i:=matchersPosEnd to Length(fParseString)-1 do
      begin
        if fParseString[i]='[' then
        begin
          nextSectionPos:=i;
          Break;
        end;
      end;
      if (index<matchersPosEnd) then
        Delete(fParseString, index, 1)
      else
        if (nextSectionPos<>0) and (index>nextSectionPos) then
            Delete(fParseString, index, 1);
    end;
    index:= Pos(#32, fParseString, Low(string));
    Inc(lenPosition);
  end;

  // Clean quotes
  // Single Quote
  index:= Pos(#39, fParseString, Low(string));
  while index<>0 do
  begin
    Delete(fParseString, index, 1);
    index:= Pos(#39, fParseString, Low(string));
  end;

  // Double Quote
  index:= Pos(#34, fParseString, Low(string));
  while index<>0 do
  begin
    Delete(fParseString, index, 1);
    index:= Pos(#34, fParseString, Low(string));
  end;


end;

{ TParser }

function TParser.getErrorMessage: string;
begin
  Result:=fErrorMessage;
end;

function TParser.getLogger: ILogger;
begin
  Result:=fLogger;
end;

function TParser.getNodes: TNodeCollection;
begin
  Result:=fNodes;
end;

function TParser.getParseType: TParseType;
begin
  Result:=fParseType;
end;

function TParser.getStatus: TParserStatus;
begin
  Result:=fStatus;
end;

procedure TParser.parse;
begin
  fErrorMessage:='';
  fNodes.Headers.Clear;
  fStatus:=psRunning;
  fLogger.log('Parser started');


  fLogger.log('Cleaning whitespace...');
  cleanWhiteSpace;
  fLogger.log('Cleaning of whitespace finished');

  if fStatus<>psError then
  begin
    fLogger.log('Checking for Syntax Errors...');
    checkSyntaxErrors;
    fLogger.log('Syntax error check completed');
  end;

  if fStatus<>psError then
  begin
    fLogger.log('Checking headers...');
    checkHeaders;
    fLogger.log('Check of headers completed');
  end;

  if fStatus<>psError then
  begin
    fLogger.log('Parsing content...');
    parseContent;
    fLogger.log('Content parse completed');
  end;

  if fStatus=psError then
  begin
    fLogger.log('Error while parsing: '+fErrorMessage+EOL+'Parsing failed');
  end
  else
    fStatus:=psIdle;

  fLogger.log('Parser finished');
end;

procedure TParser.parseContent;
var
  mainLines: TStringList;
  line: string;
  tmpStr: string;
  header: THeaderNode;   //PALOFF
  startPos: Integer;
  endPos: Integer;
begin
  mainLines:=TStringList.Create;
  try
    mainLines.Text:=fParseString;

    startPos:=findStartPos;
    header:=nil;
    for line in mainLines do
    begin
      endPos:=findEndPos(line);
      if (Trim(line)<>'') and (line[Low(string)]='[') and (line[endPos]=']') then
      begin
        tmpStr:=Copy(Copy(line, startPos, endPos-1), startPos+1,
                                                          endPos-1);
        header:=THeaderNode.Create;  //PALOFF
        header.Value:=tmpStr;
        case IndexStr(UpperCase(tmpStr),
                      [UpperCase(defaultSection.Header),
                       UpperCase(requestDefinition.Header),
                       UpperCase(policyDefinition.Header),
                       UpperCase(roleDefinition.Header),
                       UpperCase(policyEffectDefinition.Header),
                       UpperCase(matchersDefinition.Header)]) of
          0: header.SectionType:=stDefault;
          1: header.SectionType:=stRequestDefinition;
          2: header.SectionType:=stPolicyDefinition;
          3: header.SectionType:=stRoleDefinition;
          4: header.SectionType:=stPolicyEffect;
          5: header.SectionType:=stMatchers;
        else
          header.SectionType:=stUnknown;
        end;
        fNodes.Headers.Add(header);
      end
      else
      begin
        if Assigned(header) then
        begin
          if fParseType=ptPolicy then
            header.SectionType:=stPolicyRules;
          if Trim(line)<>'' then
          begin
            addAssertion(header, line);
            if (header.SectionType=stPolicyEffect) and
              ((header.ChildNodes.Items
                  [header.ChildNodes.Count-1] as TEffectNode)
                                              .EffectCondition=ecUnknown) then
            begin
              fErrorMessage:=format(errorUnknownAssertion, [line]);
              fStatus:=psError;
              Exit;
            end;
          end;
        end;
      end;
    end;
  finally
    mainLines.Free;
  end;
end;

procedure TParser.setLogger(const aValue: ILogger);
begin
  fLogger:=aValue;
end;

end.
