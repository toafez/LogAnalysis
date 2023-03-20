Ext.namespace("SYNO.SDS.LogAnalysis.Utils");

Ext.apply(SYNO.SDS.LogAnalysis.Utils, function(){
    return{
        getMainHtml: function(){
            // Timestamp must be inserted here to prevent caching of iFrame
            return '<iframe src="webman/3rdparty/LogAnalysis/index.cgi?_ts=' + new Date().getTime() + '" title="react-app" style="width: 100%; height: 100%; border: none; margin: 0"/>';
        },
    }
}());

Ext.define("SYNO.SDS.LogAnalysis.Application", {
    extend: "SYNO.SDS.AppInstance",
    appWindowName: "SYNO.SDS.LogAnalysis.MainWindow",
    constructor: function(){
        this.callParent(arguments);
    }
});
 
Ext.define("SYNO.SDS.LogAnalysis.MainWindow", {
    extend: "SYNO.SDS.AppWindow",
    constructor : function(a){
        var MY = SYNO.SDS.LogAnalysis;
        this.appInstance = a.appInstance;
        MY.MainWindow.superclass.constructor.call(this, Ext.apply({
            layout : "fit",
            resizable : true,
            cls: "syno-my-win",
            maximizable : true,
            minimizable : true,
            width : 1024,
            height : 768,
            html: MY.Utils.getMainHtml()
        }, a));
        MY.Utils.ApplicationWindow = this;
    },

    onOpen : function(){
        SYNO.SDS.LogAnalysis.MainWindow.superclass.onOpen.apply(this, arguments);
    },

    onRequest : function(a){
        SYNO.SDS.LogAnalysis.MainWindow.superclass.onRequest.call(this, a);
    },

    onClose : function(){
        clearTimeout(SYNO.SDS.LogAnalysis.TimeOutID);
        SYNO.SDS.LogAnalysis.TimeOutID = undefined;
        SYNO.SDS.LogAnalysis.MainWindow.superclass.onClose.apply(this, arguments);
        this.doClose();
        return true;
    }
});