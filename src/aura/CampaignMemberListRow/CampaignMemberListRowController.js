({
	goToRecord : function(component, event, helper) {
        var action = $A.get("e.force:navigateToSObject");
        action.setParams({
            "recordId": component.get("v.cmember.ContactId")
        });
        action.fire();
	}
})