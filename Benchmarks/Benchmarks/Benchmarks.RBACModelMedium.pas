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
unit Benchmarks.RBACModelMedium;

interface

uses
  Core.Benchmark.Base, Casbin.Types;

type
  TBenchmarkRBACModelMedium = class (TBaseBenchmark)
  private
    fCasbin: ICasbin;
  public
    procedure runBenchmark; override;
    procedure setDown; override;
    procedure setUp; override;
  end;

implementation

uses
  Casbin, Casbin.Model.Sections.Types, System.SysUtils;

{ TBenchmarkRBACModelSmall }

procedure TBenchmarkRBACModelMedium.runBenchmark;
var
  i: Integer;
begin
  inherited;
  for i:=0 to Operations do
  begin
    fCasbin.enforce(['user5001','data150','read']);
    Percentage:=i / Operations;
  end;
end;

procedure TBenchmarkRBACModelMedium.setDown;
begin
  inherited;

end;

procedure TBenchmarkRBACModelMedium.setUp;
var
  i: integer;
begin
  inherited;
  fCasbin:=TCasbin.Create('..\..\..\Examples\Default\rbac_model.conf', '');

  // 1000 roles, 100 resources
  for i := 1 to 1000 do
  begin
    fCasbin.Policy.addPolicy(stPolicyRules, 'p',
              format('group%d, data%d, read', [i, Round(i/10)]));
    Percentage:= i / 1000;
  end;

  // 10000 users
  for i:=1 to 10000 do
  begin
    fCasbin.Policy.addPolicy(stRoleRules, 'g',
              format('user%d, group%d', [i, round(i/10)]));
    Percentage:= i / 10000;
  end;
end;

end.

