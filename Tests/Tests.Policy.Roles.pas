unit Tests.Policy.Roles;

interface
uses
  DUnitX.TestFramework, Casbin.Policy.Types, System.Types;

type

  [TestFixture]
  TTestPolicyRoles = class(TObject)
  private
    fPolicy: IPolicyManager;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    // From role_manager_test.go - TestRole
    [TestCase ('NormalRole.1', 'u1,g1#true', '#')]
    [TestCase ('NormalRole.2', 'u1,g2#false', '#')]
    [TestCase ('NormalRole.3', 'u1,g3#true', '#')]

    [TestCase ('NormalRole.4', 'u2,g1#true', '#')]
    [TestCase ('NormalRole.5', 'u2,g2#false', '#')]
    [TestCase ('NormalRole.6', 'u2,g3#true', '#')]

    [TestCase ('NormalRole.7', 'u3,g1#false', '#')]
    [TestCase ('NormalRole.8', 'u3,g2#true', '#')]
    [TestCase ('NormalRole.9', 'u3,g3#false', '#')]

    [TestCase ('NormalRole.10', 'u4,g1#false', '#')]
    [TestCase ('NormalRole.11', 'u4,g2#true', '#')]
    [TestCase ('NormalRole.12', 'u4,g3#true', '#')]
    [testCase ('NormalRole.13', 'u1,u2#false', '#')]
    procedure testRolesNormal(const aLeft, aRight: string; const aResult: boolean);

    [Test]
    // From role_manager_test.go - TestRole
    [TestCase ('NormalRole.1', 'u1,g1#true', '#')]
    [TestCase ('NormalRole.2', 'u1,g2#false', '#')]
    [TestCase ('NormalRole.3', 'u1,g3#false', '#')]

    [TestCase ('NormalRole.4', 'u2,g1#true', '#')]
    [TestCase ('NormalRole.5', 'u2,g2#false', '#')]
    [TestCase ('NormalRole.6', 'u2,g3#false', '#')]

    [TestCase ('NormalRole.7', 'u3,g1#false', '#')]
    [TestCase ('NormalRole.8', 'u3,g2#true', '#')]
    [TestCase ('NormalRole.9', 'u3,g3#false', '#')]

    [TestCase ('NormalRole.10', 'u4,g1#false', '#')]
    [TestCase ('NormalRole.11', 'u4,g2false', '#')]
    [TestCase ('NormalRole.12', 'u4,g3#true', '#')]
    procedure testRolesNormalDelete(const aLeft, aRight: string; const aResult:
        boolean);

    [Test]
    // From role_manager_test.go - TestDomainRole
    [TestCase ('DomainRole.1', 'u1,g1,domain1#true', '#')]
    [TestCase ('DomainRole.2', 'u1,g1,domain2#false', '#')]
    [TestCase ('DomainRole.3', 'u1,admin,domain1#true', '#')]
    [TestCase ('DomainRole.4', 'u1,admin,domain2#false', '#')]

    [TestCase ('DomainRole.5', 'u2,g1,domain1#true', '#')]
    [TestCase ('DomainRole.6', 'u2,g1,domain2#false', '#')]
    [TestCase ('DomainRole.7', 'u2,admin,domain1#true', '#')]
    [TestCase ('DomainRole.8', 'u2,admin,domain2#false', '#')]

    [TestCase ('DomainRole.9', 'u3,g1,domain1#false', '#')]
    [TestCase ('DomainRole.10', 'u3,g1,domain2#false', '#')]
    [TestCase ('DomainRole.11', 'u3,admin,domain1#false', '#')]
    [TestCase ('DomainRole.12', 'u3,admin,domain2#true', '#')]

    [TestCase ('DomainRole.13', 'u4,g1,domain1#false', '#')]
    [TestCase ('DomainRole.14', 'u4,g1,domain2#false', '#')]
    [TestCase ('DomainRole.15', 'u4,admin,domain1#true', '#')]
    [TestCase ('DomainRole.16', 'u4,admin,domain2#true', '#')]

    procedure testRolesDomainNormal (const aLeft: string; const aRight: string;
                                  const aDomain: string;const aResult: Boolean);

    [Test]
    // From role_manager_test.go - TestDomainRole
    [TestCase ('DomainRole.1', 'u1,g1,domain1#true', '#')]
    [TestCase ('DomainRole.2', 'u1,g1,domain2#false', '#')]
    [TestCase ('DomainRole.3', 'u1,admin,domain1#false', '#')]
    [TestCase ('DomainRole.4', 'u1,admin,domain2#false', '#')]

    [TestCase ('DomainRole.5', 'u2,g1,domain1#true', '#')]
    [TestCase ('DomainRole.6', 'u2,g1,domain2#false', '#')]
    [TestCase ('DomainRole.7', 'u2,admin,domain1#false', '#')]
    [TestCase ('DomainRole.8', 'u2,admin,domain2#false', '#')]

    [TestCase ('DomainRole.9', 'u3,g1,domain1#false', '#')]
    [TestCase ('DomainRole.10', 'u3,g1,domain2#false', '#')]
    [TestCase ('DomainRole.11', 'u3,admin,domain1#false', '#')]
    [TestCase ('DomainRole.12', 'u3,admin,domain2#true', '#')]

    [TestCase ('DomainRole.13', 'u4,g1,domain1#false', '#')]
    [TestCase ('DomainRole.14', 'u4,g1,domain2#false', '#')]
    [TestCase ('DomainRole.15', 'u4,admin,domain1#true', '#')]
    [TestCase ('DomainRole.16', 'u4,admin,domain2#false', '#')]

    procedure testRolesDomainDelete (const aLeft: string; const aRight: string;
                                  const aDomain: string;const aResult: Boolean);

    [Test]
    // From role_manager_test.go - TestClear
    [TestCase ('Clear.1', 'u1,g1#false', '#')]
    [TestCase ('Clear.2', 'u1,g2#false', '#')]
    [TestCase ('Clear.3', 'u1,g3#false', '#')]

    [TestCase ('Clear.4', 'u2,g1#false', '#')]
    [TestCase ('Clear.5', 'u2,g2#false', '#')]
    [TestCase ('Clear.6', 'u2,g3#false', '#')]

    [TestCase ('Clear.7', 'u3,g1#false', '#')]
    [TestCase ('Clear.8', 'u3,g2#false', '#')]
    [TestCase ('Clear.9', 'u3,g3#false', '#')]

    [TestCase ('Clear.10', 'u4,g1#false', '#')]
    [TestCase ('Clear.11', 'u4,g2#false', '#')]
    [TestCase ('Clear.12', 'u4,g3#false', '#')]
    procedure testClear(const aLeft, aRight: string; const aResult: boolean);

    [Test]
    [TestCase ('RolesForEntity.1', 'u1#g1', '#')]
    [TestCase ('RolesForEntity.2', 'u2#g1', '#')]
    [TestCase ('RolesForEntity.3', 'u3#g2', '#')]
    [TestCase ('RolesForEntity.4', 'u4#g2,g3', '#')]
    [TestCase ('RolesForEntity.5', 'g1#g3', '#')]
    [TestCase ('RolesForEntity.6', 'g2# ', '#')]
    [TestCase ('RolesForEntity.7', 'g3# ', '#')]
    procedure testRolesForEntityNormal(const aEntity, aExpected: string);

    [Test]
    [TestCase ('RolesForEntity.1', 'u1#g1', '#')]
    [TestCase ('RolesForEntity.2', 'u2#g1', '#')]
    [TestCase ('RolesForEntity.3', 'u3#g2', '#')]
    [TestCase ('RolesForEntity.4', 'u4#g3', '#')]
    [TestCase ('RolesForEntity.5', 'g1# ', '#')]
    [TestCase ('RolesForEntity.6', 'g2# ', '#')]
    [TestCase ('RolesForEntity.7', 'g3# ', '#')]
    procedure testRolesForEntityDeleted(const aEntity, aExpected: string);

    [Test]
    [TestCase ('EntitiesForRole.1', 'u1#', '#')]
    [TestCase ('EntitiesForRole.2', 'u2#', '#')]
    [TestCase ('EntitiesForRole.3', 'u3#', '#')]
    [TestCase ('EntitiesForRole.4', 'u4#', '#')]
    [TestCase ('EntitiesForRole.5', 'g1#u1,u2', '#')]
    [TestCase ('EntitiesForRole.6', 'g2#u3,u4', '#')]
    [TestCase ('EntitiesForRole.7', 'g3#g1,u4', '#')]
    procedure testEntitiesForRoleNormal(const aEntity, aExpected: string);

    [Test]
    // From rbac_api_test.go
    procedure testRoleAPI;

    [Test]
    // From rbac_api_test.go
    procedure testPermissionAPI;

    [Test]
    // From rbac_api_with_domains_test.go
    procedure testUserRBACAPIWithDomains;

  end;

implementation

uses
  Casbin.Policy, System.SysUtils, Casbin.Model.Sections.Types,
  Casbin.Model.Types, Casbin.Types, Casbin;

procedure TTestPolicyRoles.Setup;
begin
  fPolicy:=TPolicyManager.Create;
end;

procedure TTestPolicyRoles.TearDown;
begin
end;

procedure TTestPolicyRoles.testClear(const aLeft, aRight: string;
  const aResult: boolean);
begin
	// Current role inheritance tree:
	//             g3    g2
	//            /  \  /  \
	//          g1    u4    u3
	//         /  \
	//       u1    u2

  fPolicy.clearRoles;

  fPolicy.addLink('u1','g1');
  fPolicy.addLink('u2','g1');
  fPolicy.addLink('u3','g2');
  fPolicy.addLink('u4','g2');
  fPolicy.addLink('u4','g3');
  fPolicy.addLink('g1','g3');

  fPolicy.clearRoles;

  Assert.AreEqual(aResult, fPolicy.linkExists(aLeft, aRight));
end;

procedure TTestPolicyRoles.testEntitiesForRoleNormal(const aEntity,
  aExpected: string);
var
  actString: string;
  actArray: TStringDynArray;
begin
	// Current role inheritance tree:
	//             g3    g2
	//            /  \  /  \
	//          g1    u4    u3
	//         /  \
	//       u1    u2

  fPolicy.clearRoles;
  fPolicy.addLink('u1','g1');
  fPolicy.addLink('u2','g1');
  fPolicy.addLink('u3','g2');
  fPolicy.addLink('u4','g2');
  fPolicy.addLink('u4','g3');
  fPolicy.addLink('g1','g3');

  actArray:=fPolicy.EntitiesForRole(aEntity);
  actString:=string.Join(',', actArray);
  Assert.AreEqual(Trim(aExpected), Trim(actString));
end;

procedure TTestPolicyRoles.testPermissionAPI;
var
  casbin: ICasbin;
  permissions: TStringDynArray;
begin
  casbin:=TCasbin.Create('..\..\..\Examples\Default\basic_without_resources_model.conf',
            '..\..\..\Examples\Default\basic_without_resources_policy.csv');
  casbin.Policy.Adapter.AutoSave:=False;

  Assert.AreEqual(True, casbin.enforce(['alice','read']), 'Start.1');
  Assert.AreEqual(False, casbin.enforce(['alice','write']),'Start.2');
  Assert.AreEqual(False, casbin.enforce(['bob','read']),'Start.3');
  Assert.AreEqual(True, casbin.enforce(['bob','write']),'Start.4');

  //////////
  permissions:=casbin.Policy.permissionsForEntity('alice');
  Assert.IsTrue(Length(permissions) = 1, 'Permission.1');
  Assert.IsTrue(permissions[0] = 'read', 'Permission.2');

  permissions:=casbin.Policy.permissionsForEntity('bob');
  Assert.IsTrue(Length(permissions) = 1, 'Permission.3');
  Assert.IsTrue(permissions[0] = 'write', 'Permission.4');

  Assert.IsTrue(casbin.Policy.permissionExists('alice','read'), 'Permission.5');
  Assert.IsFalse(casbin.Policy.permissionExists('alice','write'), 'Permission.6');
  Assert.IsFalse(casbin.Policy.permissionExists('bob','read'), 'Permission.7');
  Assert.IsTrue(casbin.Policy.permissionExists('bob','write'), 'Permission.8');

  //////////
  casbin.Policy.removePolicy(['read','*']);
  Assert.AreEqual(False, casbin.enforce(['alice','read']), 'DeleteRead.1');
  Assert.AreEqual(False, casbin.enforce(['alice','write']),'DeleteRead.2');
  Assert.AreEqual(False, casbin.enforce(['bob','read']),'DeleteRead.3');
  Assert.AreEqual(True, casbin.enforce(['bob','write']),'DeleteRead.4');

  casbin.Policy.addPolicy(stPolicyRules,'p','bob, read');
  Assert.AreEqual(False, casbin.enforce(['alice','read']), 'AddBobRead.1');
  Assert.AreEqual(False, casbin.enforce(['alice','write']),'AddBobRead.2');
  Assert.AreEqual(True, casbin.enforce(['bob','read']),'AddBobRead.3');
  Assert.AreEqual(True, casbin.enforce(['bob','write']),'AddBobRead.4');

  casbin.Policy.removePolicy(['bob','read']);
  Assert.AreEqual(False, casbin.enforce(['alice','read']), 'DeleteBobRead.1');
  Assert.AreEqual(False, casbin.enforce(['alice','write']),'DeleteBobRead.2');
  Assert.AreEqual(False, casbin.enforce(['bob','read']),'DeleteBobRead.3');
  Assert.AreEqual(True, casbin.enforce(['bob','write']),'DeleteBobRead.4');

  casbin.Policy.removePolicy(['bob','*']);
  Assert.AreEqual(False, casbin.enforce(['alice','read']), 'DeleteBob.1');
  Assert.AreEqual(False, casbin.enforce(['alice','write']),'DeleteBob.2');
  Assert.AreEqual(False, casbin.enforce(['bob','read']),'DeleteBob.3');
  Assert.AreEqual(False, casbin.enforce(['bob','write']),'DeleteBob.4');

end;

procedure TTestPolicyRoles.testUserRBACAPIWithDomains;
var
  casbin: ICasbin;
  entities: TStringDynArray;
begin
  casbin:=TCasbin.Create('..\..\..\Examples\Default\rbac_with_domains_model.conf',
        '..\..\..\Examples\Default\rbac_with_domains_policy.csv');
  casbin.Policy.Adapter.AutoSave:=False;

  entities:=casbin.Policy.entitiesForRole('admin','domain1');
  Assert.IsTrue(Length(entities) = 1, 'Api-Domain.1');
  Assert.AreEqual('alice', entities[0], 'Api-Domain.2');

  entities:=casbin.Policy.entitiesForRole('non_exist','domain1');
  Assert.IsTrue(Length(entities) = 0, 'Api-Domain.3');

  entities:=casbin.Policy.entitiesForRole('admin','domain2');
  Assert.IsTrue(Length(entities) = 1, 'Api-Domain.4');
  Assert.AreEqual('bob', entities[0], 'Api-Domain.5');

  casbin.Policy.removePolicy(['alice','admin','domain1']);
  casbin.Policy.addPolicy(stRoleRules, 'g', 'bob, admin, domain1');

  entities:=casbin.Policy.entitiesForRole('admin','domain1');
  Assert.IsTrue(Length(entities) = 1, 'Api-Domain.6');
  Assert.AreEqual('bob', entities[0], 'Api-Domain.7');

  entities:=casbin.Policy.entitiesForRole('non_exist','domain1');
  Assert.IsTrue(Length(entities) = 0, 'Api-Domain.8');

  entities:=casbin.Policy.entitiesForRole('admin','domain2');
  Assert.IsTrue(Length(entities) = 1, 'Api-Domain.9');
  Assert.AreEqual('bob', entities[0], 'Api-Domain.10');

  entities:=casbin.Policy.entitiesForRole('non_exist','domain2');
  Assert.IsTrue(Length(entities) = 0, 'Api-Domain.11');
end;

procedure TTestPolicyRoles.testRoleAPI;
var
  casbin: ICasbin;
  policy: IPolicyManager;
  roles: TStringDynArray;
begin
  policy:=TPolicyManager.Create
    ('..\..\..\Examples\Default\rbac_policy.csv');
  policy.Adapter.AutoSave:=False;

  ///////////////////////
  roles:=[];
  roles:=policy.rolesForEntity('alice');
  Assert.IsTrue(Length(roles) = 1, 'Alice.1');
  Assert.AreEqual('data2_admin', roles[0], 'g.1');

  roles:=[];
  roles:=policy.rolesForEntity('bob');
  Assert.IsTrue(Length(roles) = 0, 'Bob.1');

  roles:=[];
  roles:=policy.rolesForEntity('data2_admin');
  Assert.IsTrue(Length(roles) = 0, 'Data2_admin.1');

  roles:=[];
  roles:=policy.rolesForEntity('non_exist');
  Assert.IsTrue(Length(roles) = 0, 'Non_exist.1');

  ///////////////////////
  policy.addPolicy(stRoleRules,'g','alice, data1_admin');
  roles:=[];
  roles:=policy.rolesForEntity('alice');
  Assert.IsTrue(Length(roles) = 2, 'Alice.2');
  Assert.AreEqual('data1_admin', roles[0],'g.2');
  Assert.AreEqual('data2_admin', roles[1],'g.3');

  roles:=[];
  roles:=policy.rolesForEntity('bob');
  Assert.IsTrue(Length(roles) = 0, 'Bob.2');

  roles:=[];
  roles:=policy.rolesForEntity('data2_admin');
  Assert.IsTrue(Length(roles) = 0, 'Data2_admin.2');

  ///////////////
  policy.removePolicy(['alice','data1_admin']);
  roles:=[];
  roles:=policy.rolesForEntity('alice');
  Assert.IsTrue(Length(roles) = 1, 'Alice.3');
  Assert.AreEqual('data2_admin', roles[0], 'g.4');

  roles:=[];
  roles:=policy.rolesForEntity('bob');
  Assert.IsTrue(Length(roles) = 0, 'Bob.3');

  roles:=[];
  roles:=policy.rolesForEntity('data2_admin');
  Assert.IsTrue(Length(roles) = 0, 'Data2_admin.3');


  ///////////////
  policy.removePolicy(['alice','*'], rmNonImplicit);
  roles:=[];
  roles:=policy.rolesForEntity('alice');
  Assert.IsTrue(Length(roles) = 0, 'Alice.4');

  roles:=[];
  roles:=policy.rolesForEntity('bob');
  Assert.IsTrue(Length(roles) = 0, 'Bob.4');

  roles:=[];
  roles:=policy.rolesForEntity('data2_admin');
  Assert.IsTrue(Length(roles) = 0, 'Data2_admin.4');

  ///////////////////////
  policy.addPolicy(stRoleRules,'g','alice, data1_admin');
  policy.removePolicy(['alice','*'], rmNonImplicit);
  roles:=[];
  roles:=policy.rolesForEntity('alice');
  Assert.IsTrue(Length(roles) = 0, 'Alice.5');

  roles:=[];
  roles:=policy.rolesForEntity('bob');
  Assert.IsTrue(Length(roles) = 0, 'Bob.5');

  roles:=[];
  roles:=policy.rolesForEntity('data2_admin');
  Assert.IsTrue(Length(roles) = 0, 'Data2_admin.5');

  ///////////////////////
  policy.addPolicy(stRoleRules, 'g', 'alice, data2_admin');

  casbin:=TCasbin.Create('..\..\..\Examples\Default\rbac_model.conf', policy);
  Assert.AreEqual(True, casbin.enforce(['alice', 'data1', 'read']), 'Add.1');
  Assert.AreEqual(False, casbin.enforce(['alice', 'data1', 'write']), 'Add.2');
  Assert.AreEqual(True, casbin.enforce(['alice', 'data2', 'read']), 'Add.3');
  Assert.AreEqual(True, casbin.enforce(['alice', 'data2', 'write']), 'Add.4');

  Assert.AreEqual(False, casbin.enforce(['bob', 'data1', 'read']), 'Add.5');
  Assert.AreEqual(False, casbin.enforce(['bob', 'data1', 'write']), 'Add.6');
  Assert.AreEqual(False, casbin.enforce(['bob', 'data2', 'read']), 'Add.7');
  Assert.AreEqual(True, casbin.enforce(['bob', 'data2', 'write']), 'Add.8');

  policy.removePolicy(['data2_admin','*']);
  Assert.AreEqual(True, casbin.enforce(['alice', 'data1', 'read']), 'Remove.1');
  Assert.AreEqual(False, casbin.enforce(['alice', 'data1', 'write']), 'Remove.2');
  Assert.AreEqual(False, casbin.enforce(['alice', 'data2', 'read']), 'Remove.3');
  Assert.AreEqual(False, casbin.enforce(['alice', 'data2', 'write']), 'Remove.4');

  Assert.AreEqual(False, casbin.enforce(['bob', 'data1', 'read']), 'Remove.5');
  Assert.AreEqual(False, casbin.enforce(['bob', 'data1', 'write']), 'Remove.6');
  Assert.AreEqual(False, casbin.enforce(['bob', 'data2', 'read']), 'Remove.7');
  Assert.AreEqual(True, casbin.enforce(['bob', 'data2', 'write']), 'Remove.8');

end;

procedure TTestPolicyRoles.testRolesDomainDelete(const aLeft, aRight,
  aDomain: string; const aResult: Boolean);
begin
	// Current role inheritance tree:
	//       domain1:admin    domain2:admin
	//                    \          \
	//      domain1:g1     u4         u3
	//         /  \
	//       u1    u2

  fPolicy.clear;
  fPolicy.addLink('u1', 'domain1', 'g1');
  fPolicy.addLink('u2', 'domain1', 'g1');
  fPolicy.addLink('u3', 'domain2', 'admin');
  fPolicy.addLink('u4', 'domain2', 'admin');
  fPolicy.addLink('u4', 'domain1', 'admin');
  fPolicy.addLink('g1', 'domain1', 'admin');

  fPolicy.removeLink('g1', 'domain1', 'admin');
  fPolicy.removeLink('u4', 'domain2', 'admin');

  Assert.AreEqual(aResult, fPolicy.linkExists(aLeft, aDomain, aRight));
end;

procedure TTestPolicyRoles.testRolesDomainNormal(const aLeft, aRight,
  aDomain: string; const aResult: Boolean);
begin
	// Current role inheritance tree:
	//       domain1:admin    domain2:admin
	//            /       \  /       \
	//      domain1:g1     u4         u3
	//         /  \
	//       u1    u2

  fPolicy.clear;
  fPolicy.addLink('u1', 'domain1', 'g1');
  fPolicy.addLink('u2', 'domain1', 'g1');
  fPolicy.addLink('u3', 'domain2', 'admin');
  fPolicy.addLink('u4', 'domain2', 'admin');
  fPolicy.addLink('u4', 'domain1', 'admin');
  fPolicy.addLink('g1', 'domain1', 'admin');

  Assert.AreEqual(aResult, fPolicy.linkExists(aLeft, aDomain, aRight));
end;

procedure TTestPolicyRoles.testRolesForEntityDeleted(const aEntity,
  aExpected: string);
var
  actString: string;
  actArray: TStringDynArray;
begin
	// Current role inheritance tree:
	//             g3    g2
	//            /  \  /  \
	//          g1    u4    u3
	//         /  \
	//       u1    u2

  fPolicy.clearRoles;
  fPolicy.addLink('u1','g1');
  fPolicy.addLink('u2','g1');
  fPolicy.addLink('u3','g2');
  fPolicy.addLink('u4','g2');
  fPolicy.addLink('u4','g3');
  fPolicy.addLink('g1','g3');

  fPolicy.removeLink('g1','g3');
  fPolicy.removeLink('u4','g2');

  actArray:=fPolicy.rolesForEntity(aEntity);
  actString:=string.Join(',', actArray);
  Assert.AreEqual(Trim(aExpected), Trim(actString));
end;

procedure TTestPolicyRoles.testRolesForEntityNormal(const aEntity, aExpected:
    string);
var
  actString: string;
  actArray: TStringDynArray;
begin
	// Current role inheritance tree:
	//             g3    g2
	//            /  \  /  \
	//          g1    u4    u3
	//         /  \
	//       u1    u2

  fPolicy.clearRoles;
  fPolicy.addLink('u1','g1');
  fPolicy.addLink('u2','g1');
  fPolicy.addLink('u3','g2');
  fPolicy.addLink('u4','g2');
  fPolicy.addLink('u4','g3');
  fPolicy.addLink('g1','g3');

  actArray:=fPolicy.rolesForEntity(aEntity);
  actString:=string.Join(',', actArray);
  Assert.AreEqual(Trim(aExpected), Trim(actString));

end;

procedure TTestPolicyRoles.testRolesNormal(const aLeft, aRight: string; const
    aResult: boolean);
begin
	// Current role inheritance tree:
	//             g3    g2
	//            /  \  /  \
	//          g1    u4    u3
	//         /  \
	//       u1    u2

  fPolicy.clearRoles;
  fPolicy.addLink('u1','g1');
  fPolicy.addLink('u2','g1');
  fPolicy.addLink('u3','g2');
  fPolicy.addLink('u4','g2');
  fPolicy.addLink('u4','g3');
  fPolicy.addLink('g1','g3');

  Assert.AreEqual(aResult, fPolicy.linkExists(aLeft, aRight));
end;


procedure TTestPolicyRoles.testRolesNormalDelete(const aLeft, aRight: string;
    const aResult: boolean);
begin
	// Current role inheritance tree:
	//             g3    g2
	//               \     \
	//          g1    u4    u3
	//         /  \
	//       u1    u2

  fPolicy.clearRoles;
  fPolicy.addLink('u1','g1');
  fPolicy.addLink('u2','g1');
  fPolicy.addLink('u3','g2');
  fPolicy.addLink('u4','g2');
  fPolicy.addLink('u4','g3');
  fPolicy.addLink('g1','g3');

  fPolicy.removeLink('g1', 'g3');
  fPolicy.removeLink('u4', 'g2');

  Assert.AreEqual(aResult, fPolicy.linkExists(aLeft, aRight));
end;

initialization
  TDUnitX.RegisterTestFixture(TTestPolicyRoles);
end.
