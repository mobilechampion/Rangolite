


var HelloPlugin = {
 


callNativeFunction: function (success, fail, resultType) {
    
    
  return Cordova.exec( success, fail, "HelloPluginP", "nativeFunction", [resultType]);
  

}
  };