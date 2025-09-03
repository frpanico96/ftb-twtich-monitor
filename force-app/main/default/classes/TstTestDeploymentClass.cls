@isTest
public with sharing class TstTestDeploymentClass {

    @isTest
    static voide testDemoMethod(){
        Test.startTest();
        TestDeploymentClass.demoMethod();
        Test.stopTest();
        Assert.areEqual(1, 1);
    }

}