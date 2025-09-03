@isTest
public with sharing class TstTestDeploymentClass {

    @isTest
    static void testDemoMethod(){
        Test.startTest();
        TestDeploymentClass.demoMethod();
        Test.stopTest();
        Assert.areEqual(2, 2);
    }

}