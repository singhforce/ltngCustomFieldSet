({
	getsObjectRecs : function(component) {
        var action = component.get("c.getsObjRecords");
        action.setParams({
            "sObj" : component.get("v.sObj"),
            "fSetName" : component.get("v.fSetName")
        });
        action.setCallback(this, function(resp) {
            var state=resp.getState();
            if(state === "SUCCESS"){
                console.log(resp.getReturnValue());
                var response = resp.getReturnValue();
                
                var sObjlist = response["sObjlist"];
                var fSetlist = response["fieldSetlist"];
                
                component.set("v.fieldlist", fSetlist);
                
                var objWrapperlist = [];
                    
                for (var sObj=0; sObj<sObjlist.length; sObj++){
                    var objRec = []; 
                    for (var fSet=0; fSet<fSetlist.length; fSet++){
                        var fAPIname = fSetlist[fSet].fAPIName;
                        var fValue = sObjlist[sObj].sObjRecord[fAPIname];
                        var jsonStr = JSON.parse(fSetlist[fSet].fSetMember);
                    
                        objRec.push({"fvalue" : fValue,
                                    "fDetails" : jsonStr
                                    });
                    }
                    objWrapperlist.push(objRec);
                }
                console.log(objWrapperlist.length);
                component.set("v.sObjWrapperlist", objWrapperlist);
            }
        });
        $A.enqueueAction(action); 
    }
})