((function(){var a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s=Array.prototype.slice,t=function(a,b){return function(){return a.apply(b,arguments)}},u=Array.prototype.indexOf||function(a){for(var b=0,c=this.length;b<c;b++)if(b in this&&this[b]===a)return b;return-1};window.sharejs=k={version:"0.5.0-pre"},m=function(a){return setTimeout(a,0)},e=function(){function a(){}return a.prototype.on=function(a,b){var c;return this._events||(this._events={}),(c=this._events)[a]||(c[a]=[]),this._events[a].push(b),this},a.prototype.removeListener=function(a,b){var c,d,e,f=this;this._events||(this._events={}),d=(e=this._events)[a]||(e[a]=[]),c=0;while(c<d.length)d[c]===b&&(d[c]=void 0),c++;return m(function(){var b;return f._events[a]=function(){var c,d,e=this._events[a],f=[];for(c=0,d=e.length;c<d;c++)b=e[c],b&&f.push(b);return f}.call(f)}),this},a.prototype.emit=function(){var a,b,c,d,e,f=arguments[0],g=2<=arguments.length?s.call(arguments,1):[];if((d=this._events)!=null?!d[f]:!void 0)return this;e=this._events[f];for(b=0,c=e.length;b<c;b++)a=e[b],a&&a.apply(this,g);return this},a}(),e.mixin=function(a){var b=a.prototype||a;return b.on=e.prototype.on,b.removeListener=e.prototype.removeListener,b.emit=e.prototype.emit,a},k._bt=g=function(a,b,c,d){var e,f=function(a,c,d,e){return b(d,a,c,"left"),b(e,c,a,"right")};return a.transformX=a.transformX=e=function(a,b){var g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y;c(a),c(b),k=[];for(p=0,t=b.length;p<t;p++){o=b[p],j=[],g=0;while(g<a.length){l=[],f(a[g],o,j,l),g++;if(l.length!==1){if(l.length===0){x=a.slice(g);for(q=0,u=x.length;q<u;q++)h=x[q],d(j,h);o=null;break}y=e(a.slice(g),l),i=y[0],n=y[1];for(r=0,v=i.length;r<v;r++)h=i[r],d(j,h);for(s=0,w=n.length;s<w;s++)m=n[s],d(k,m);o=null;break}o=l[0]}o!=null&&d(k,o),a=j}return[a,k]},a.transform=a.transform=function(a,c,d){var f,g,h,i,j;if(d!=="left"&&d!=="right")throw new Error("type must be 'left' or 'right'");return c.length===0?a:a.length===1&&c.length===1?b([],a[0],c[0],d):d==="left"?(i=e(a,c),f=i[0],h=i[1],f):(j=e(c,a),h=j[0],g=j[1],g)}},o={},o.name="text",o.create=o.create=function(){return""},n=function(a,b,c){return a.slice(0,b)+c+a.slice(b)},h=function(a){var b,c;if(typeof a.p!="number")throw new Error("component missing position field");c=typeof a.i,b=typeof a.d;if(!(c==="string"^b==="string"))throw new Error("component needs an i or d field");if(!(a.p>=0))throw new Error("position cannot be negative")},i=function(a){var b,c,d;for(c=0,d=a.length;c<d;c++)b=a[c],h(b);return!0},o.apply=function(a,b){var c,d,e,f;i(b);for(e=0,f=b.length;e<f;e++){c=b[e];if(c.i!=null)a=n(a,c.p,c.i);else{d=a.slice(c.p,c.p+c.d.length);if(c.d!==d)throw new Error("Delete component '"+c.d+"' does not match deleted text '"+d+"'");a=a.slice(0,c.p)+a.slice(c.p+c.d.length)}}return a},o._append=f=function(a,b){var c,d,e;if(b.i===""||b.d==="")return;return a.length===0?a.push(b):(c=a[a.length-1],c.i!=null&&b.i!=null&&c.p<=(d=b.p)&&d<=c.p+c.i.length?a[a.length-1]={i:n(c.i,b.p-c.p,b.i),p:c.p}:c.d!=null&&b.d!=null&&b.p<=(e=c.p)&&e<=b.p+b.d.length?a[a.length-1]={d:n(b.d,c.p-b.p,c.d),p:b.p}:a.push(b))},o.compose=function(a,b){var c,d,e,g;i(a),i(b),d=a.slice();for(e=0,g=b.length;e<g;e++)c=b[e],f(d,c);return d},o.compress=function(a){return o.compose([],a)},o.normalize=function(a){var b,c,d,e=[];if(a.i!=null||a.p!=null)a=[a];for(c=0,d=a.length;c<d;c++)b=a[c],b.p==null&&(b.p=0),f(e,b);return e},q=function(a,b,c){return b.i!=null?b.p<a||b.p===a&&c?a+b.i.length:a:a<=b.p?a:a<=b.p+b.d.length?b.p:a-b.d.length},o.transformCursor=function(a,b,c){var d,e,f;for(e=0,f=b.length;e<f;e++)d=b[e],a=q(a,d,c);return a},o._tc=p=function(a,b,c,d){var e,g,h,j,k,l;i([b]),i([c]);if(b.i!=null)f(a,{i:b.i,p:q(b.p,c,d==="right")});else if(c.i!=null)l=b.d,b.p<c.p&&(f(a,{d:l.slice(0,c.p-b.p),p:b.p}),l=l.slice(c.p-b.p)),l!==""&&f(a,{d:l,p:b.p+c.i.length});else if(b.p>=c.p+c.d.length)f(a,{d:b.d,p:b.p-c.d.length});else if(b.p+b.d.length<=c.p)f(a,b);else{j={d:"",p:b.p},b.p<c.p&&(j.d=b.d.slice(0,c.p-b.p)),b.p+b.d.length>c.p+c.d.length&&(j.d+=b.d.slice(c.p+c.d.length-b.p)),h=Math.max(b.p,c.p),g=Math.min(b.p+b.d.length,c.p+c.d.length),e=b.d.slice(h-b.p,g-b.p),k=c.d.slice(h-c.p,g-c.p);if(e!==k)throw new Error("Delete ops delete different text in the same region of the document");j.d!==""&&(j.p=q(j.p,c),f(a,j))}return a},l=function(a){return a.i!=null?{d:a.i,p:a.p}:{i:a.d,p:a.p}},o.invert=function(a){var b,c,d,e=a.slice().reverse(),f=[];for(c=0,d=e.length;c<d;c++)b=e[c],f.push(l(b));return f},k.types||(k.types={}),g(o,p,i,f),k.types.text=o,o.api={provides:{text:!0},getLength:function(){return this.snapshot.length},getText:function(){return this.snapshot},insert:function(a,b,c){var d=[{p:a,i:b}];return this.submitOp(d,c),d},del:function(a,b,c){var d=[{p:a,d:this.snapshot.slice(a,a+b)}];return this.submitOp(d,c),d},_register:function(){return this.on("remoteop",function(a){var b,c,d,e=[];for(c=0,d=a.length;c<d;c++)b=a[c],b.i!==void 0?e.push(this.emit("insert",b.p,b.i)):e.push(this.emit("delete",b.p,b.d));return e})}},j=function(a){return JSON.parse(JSON.stringify(a))},d=function(){function a(){this._transformParamsdAgainstParamsd=t(this._transformParamsdAgainstParamsd,this),this._transformParamsiAgainstParamsi=t(this._transformParamsiAgainstParamsi,this),this._transformParamsChangeAgainstParamsChange=t(this._transformParamsChangeAgainstParamsChange,this),this._revertParamsChange=t(this._revertParamsChange,this),this._transformParamsdAgainstParamsi=t(this._transformParamsdAgainstParamsi,this),this._transformParamsiAgainstParamsd=t(this._transformParamsiAgainstParamsd,this),this._transformParamsdAgainstTd=t(this._transformParamsdAgainstTd,this),this._transformParamsiAgainstTd=t(this._transformParamsiAgainstTd,this),this._transformTdAgainstParamsd=t(this._transformTdAgainstParamsd,this),this._transformTdAgainstParamsi=t(this._transformTdAgainstParamsi,this),this._transformParamsdAgainstTi=t(this._transformParamsdAgainstTi,this),this._transformParamsiAgainstTi=t(this._transformParamsiAgainstTi,this),this._transformTiAgainstParamsd=t(this._transformTiAgainstParamsd,this),this._transformTiAgainstParamsi=t(this._transformTiAgainstParamsi,this),this._transformParamsChangeAgainstTd=t(this._transformParamsChangeAgainstTd,this),this._transformTdAgainstParamsChange=t(this._transformTdAgainstParamsChange,this),this._transformParamsChangeAgainstTi=t(this._transformParamsChangeAgainstTi,this),this._transformTiAgainstParamsChange=t(this._transformTiAgainstParamsChange,this),this._transformTdAgainstTd=t(this._transformTdAgainstTd,this),this._transformTdAgainstTi=t(this._transformTdAgainstTi,this),this._transformTiAgainstTd=t(this._transformTiAgainstTd,this),this._transformTiAgainstTi=t(this._transformTiAgainstTi,this),this._changeParams=t(this._changeParams,this),this._applyParamsInsert=t(this._applyParamsInsert,this),this._applyParamsDelete=t(this._applyParamsDelete,this),this._applyTextDelete=t(this._applyTextDelete,this),this._applyTextInsert=t(this._applyTextInsert,this)}return a.prototype._getBlockAndOffset=function(a,b){var c,d,e,f=0;for(d=0,e=a.length;d<e;d++){c=a[d];if(f+c.t.length>b)return[d,b-f];f+=c.t.length}if(b>f)throw new Error("Specified position ("+b+") is more then text length ("+f+")");return[a.length,b-f]},a.prototype._paramsAreEqual=function(a,b){var c=function(a,b){var c;for(c in a){if(b[c]==null)return!1;if(a[c]!==b[c])return!1}return!0};return c(a,b)?c(b,a)?!0:!1:!1},a.prototype._splitBlock=function(a,b){var c;return b===0?[a]:(c=j(a),a.t=a.t.substr(0,b),c.t=c.t.substr(b),[a,c])},a.prototype._tryMerge=function(a,b,c){var d,e,f,g,h,i;b=Math.max(b,0),c=Math.min(c,a.length-1),e=c-1,i=[];while(e>=b)d=a[e],f=a[e+1],this._paramsAreEqual(d.params,f.params)&&([].splice.apply(a,[g=e+1,e+1-g+1].concat(h=[])),h,d.t+=f.t),i.push(e--);return i},a.prototype._applyTextInsert=function(a,b){var c,d,e,f,g,h,i;return a=j(a),h=this._getBlockAndOffset(a,b.p),d=h[0],g=h[1],a.length===d?(a.push({t:b.ti,params:b.params}),this._tryMerge(a,d-1,d),a):(c=a[d],this._paramsAreEqual(c.params,b.params)?c.t=c.t.substr(0,g)+b.ti+c.t.substr(g):(e=this._splitBlock(c,g),f={t:b.ti,params:b.params},[].splice.apply(e,[i=e.length-1,e.length-1-i].concat(f)),f,[].splice.apply(a,[d,d-d+1].concat(e)),e,this._tryMerge(a,d-1,d)),a)},a.prototype._applyTextDelete=function(a,b){var c,d,e,f,g,h;a=j(a),g=this._getBlockAndOffset(a,b.p),d=g[0],f=g[1],c=a[d];if(!this._paramsAreEqual(c.params,b.params))throw new Error("Text block params ("+JSON.stringify(c.params)+") do not equal to op params ("+JSON.stringify(b.params)+")");e=c.t.substr(f,b.td.length);if(e!==b.td)throw new Error("Deleted text ("+e+") is not equal to text in operation ("+b.td+")");return c.t=c.t.substr(0,f)+c.t.substr(f+b.td.length),c.t||([].splice.apply(a,[d,d-d+1].concat(h=[])),h,this._tryMerge(a,d-1,d)),a},a.prototype._getFirstParam=function(a){var b,c;for(b in a)return c=a[b],[b,c]},a.prototype._deleteParams=function(a,b){var c=this._getFirstParam(b),d=c[0],e=c[1];if(a[d]!==e)throw new Error("Params delete tried to remove param "+d+" with value "+e+" from "+JSON.stringify(a)+", but it does not match");return delete a[d]},a.prototype._applyParamsDelete=function(a,b){var c,d=this;if(Object.keys(b.paramsd).length!==1)throw new Error("Exactly one param should be deleted: "+JSON.stringify(b));return c=function(a){return d._deleteParams(a.params,b.paramsd)},this._changeParams(a,b.p,b.len,c)},a.prototype._insertParams=function(a,b){var c=this._getFirstParam(b),d=c[0],e=c[1];if(a[d]!=null)throw new Error("Params insert tried to set param "+d+" with value "+e+" to block "+JSON.stringify(a)+", but it is already set");return a[d]=e},a.prototype._applyParamsInsert=function(a,b){var c,d=this;if(Object.keys(b.paramsi).length!==1)throw new Error("Exactly one param should be inserted: "+JSON.stringify(b));return c=function(a){return d._insertParams(a.params,b.paramsi)},this._changeParams(a,b.p,b.len,c)},a.prototype._changeParams=function(a,b,c,d){var e,f,g,h,i,k,l,m,n;a=j(a),k=this._getBlockAndOffset(a,b),h=k[0],i=k[1],l=this._getBlockAndOffset(a,b+c),e=l[0],f=l[1],f===0?e--:([].splice.apply(a,[e,e-e+1].concat(m=this._splitBlock(a[e],f))),m),i>0&&([].splice.apply(a,[h,h-h+1].concat(n=this._splitBlock(a[h],i))),n,h++,e++);for(g=h;h<=e?g<=e:g>=e;h<=e?g++:g--)d(a[g]);return this._tryMerge(a,h-1,e+1),a},a.prototype._transformPosAgainstInsert=function(a,b,c,d){return b>a?a:b===a&&!d?a:a+c},a.prototype._transformPosAgainstDelete=function(a,b,c){return a>b+c?a-c:a>b?b:a},a.prototype._transformTiAgainstTi=function(a,b,c,d){return b=j(b),b.p=this._transformPosAgainstInsert(b.p,c.p,c.ti.length,d==="right"),a.push(b),a},a.prototype._transformTiAgainstTd=function(a,b,c){return b=j(b),b.p=this._transformPosAgainstDelete(b.p,c.p,c.td.length),a.push(b),a},a.prototype._transformTdAgainstTi=function(a,b,c){var d=b.td;return b.p<c.p&&(a.push({p:b.p,td:d.slice(0,c.p-b.p),params:j(b.params)}),d=d.slice(c.p-b.p)),d&&a.push({p:b.p+c.ti.length,td:d,params:j(b.params)}),a},a.prototype._transformTdAgainstTd=function(a,b,c){var d,e,f,g,h;if(b.p>=c.p+c.td.length)a.push({p:b.p-c.td.length,td:b.td,params:j(b.params)});else if(b.p+b.td.length<=c.p)a.push(j(b));else{if(!this._paramsAreEqual(b.params,c.params))throw new Error("Two text delete operations overlap but have different params: "+JSON.stringify(b)+", "+JSON.stringify(c));e=Math.max(b.p,c.p),d=Math.min(b.p+b.td.length,c.p+c.td.length),g=b.td.slice(e-b.p,d-b.p),h=c.td.slice(e-c.p,d-c.p);if(g!==h)throw new Error("Delete ops delete different text in the same region of the document: "+JSON.stringify(b)+", "+JSON.stringify(c));f={td:"",p:b.p,params:j(b.params)},b.p<c.p&&(f.td=b.td.slice(0,c.p-b.p)),b.p+b.td.length>c.p+c.td.length&&(f.td+=b.td.slice(c.p+c.td.length-b.p)),f.td&&(f.p=this._transformPosAgainstDelete(f.p,c.p,c.td.length),a.push(f))}return a},a.prototype._transformTiAgainstParamsChange=function(a,b){return a.push(j(b)),a},a.prototype._transformParamsChangeAgainstTi=function(a,b,c){var d,e,f=b.len;return b.p<c.p&&(d=Math.min(f,c.p-b.p),e=j(b),e.len=d,a.push(e),f-=d),f&&(e=j(b),e.p=Math.max(c.p,b.p)+c.ti.length,e.len=f,a.push(e)),a},a.prototype._transformTdAgainstParamsChange=function(a,b,c,d){var e,f,g;return b.p>=c.p+c.len||b.p+b.td.length<=c.p?(a.push(j(b)),a):(g=b.td,b.p<c.p&&(f=j(b),f.td=g.slice(0,c.p-b.p),a.push(f),g=g.slice(c.p-b.p)),f=j(b),e=c.p+c.len-Math.max(c.p,b.p),f.td=g.slice(0,e),d(f.params,c),g=g.slice(e),a.push(f),g&&(f=j(b),f.td=g,a.push(f)),a)},a.prototype._transformParamsChangeAgainstTd=function(a,b,c){var d;return b.p>=c.p+c.td.length?(d=j(b),d.p-=c.td.length,a.push(d)):b.p+b.len<=c.p?a.push(j(b)):(d=j(b),d.len=0,b.p<c.p&&(d.len=Math.min(b.len,c.p-b.p)),b.p+b.len>c.p+c.td.length&&(d.len+=b.p+b.len-(c.p+c.td.length)),d.len&&(d.p=this._transformPosAgainstDelete(d.p,c.p,c.td.length),a.push(d))),a},a.prototype._transformTiAgainstParamsi=function(){var a=1<=arguments.length?s.call(arguments,0):[];return this._transformTiAgainstParamsChange.apply(this,a)},a.prototype._transformTiAgainstParamsd=function(){var a=1<=arguments.length?s.call(arguments,0):[];return this._transformTiAgainstParamsChange.apply(this,a)},a.prototype._transformParamsiAgainstTi=function(){var a=1<=arguments.length?s.call(arguments,0):[];return this._transformParamsChangeAgainstTi.apply(this,a)},a.prototype._transformParamsdAgainstTi=function(){var a=1<=arguments.length?s.call(arguments,0):[];return this._transformParamsChangeAgainstTi.apply(this,a)},a.prototype._transformTdAgainstParamsi=function(a,b,c){var d=this;return this._transformTdAgainstParamsChange(a,b,c,function(a,b){return d._insertParams(a,b.paramsi)})},a.prototype._transformTdAgainstParamsd=function(a,b,c){var d=this;return this._transformTdAgainstParamsChange(a,b,c,function(a,b){return d._deleteParams(a,b.paramsd)})},a.prototype._transformParamsiAgainstTd=function(){var a=1<=arguments.length?s.call(arguments,0):[];return this._transformParamsChangeAgainstTd.apply(this,a)},a.prototype._transformParamsdAgainstTd=function(){var a=1<=arguments.length?s.call(arguments,0):[];return this._transformParamsChangeAgainstTd.apply(this,a)},a.prototype._transformParamsiAgainstParamsd=function(a,b){return a.push(j(b)),a},a.prototype._transformParamsdAgainstParamsi=function(a,b){return a.push(j(b)),a},a.prototype._revertParamsChange=function(a){var b={p:a.p,len:a.len};return a.paramsi!=null&&(b.paramsd=a.paramsi),a.paramsd!=null&&(b.paramsi=a.paramsd),b},a.prototype._transformParamsChangeAgainstParamsChange=function(a,b,c,d,e,f,g,h){var i,k,l,m;return b.p>=c.p+c.len||b.p+b.len<=c.p||e!==g?(a.push(j(b)),a):(b.p<c.p&&(m=j(b),m.len=c.p-b.p,a.push(m)),d==="left"&&f!==h&&(k=Math.min(c.p+c.len,b.p+b.len),l=Math.max(b.p,c.p),i=this._revertParamsChange(c),m=j(b),m.p=i.p=l,m.len=i.len=k-l,a.push(i),a.push(m)),b.p+b.len>c.p+c.len&&(m=j(b),m.p=c.p+c.len,m.len=b.p+b.len-(c.p+c.len),a.push(m)),a)},a.prototype._transformParamsiAgainstParamsi=function(a,b,c,d){var e=this._getFirstParam(b.paramsi),f=e[0],g=e[1],h=this._getFirstParam(c.paramsi),i=h[0],j=h[1];return this._transformParamsChangeAgainstParamsChange(a,b,c,d,f,g,i,j)},a.prototype._transformParamsdAgainstParamsd=function(a,b,c,d){var e=this._getFirstParam(b.paramsd),f=e[0],g=e[1],h=this._getFirstParam(c.paramsd),i=h[0],j=h[1];return this._transformParamsChangeAgainstParamsChange(a,b,c,d,f,g,i,j)},a.prototype._getOpType=function(a){if(a.ti!=null)return"Ti";if(a.td!=null)return"Td";if(a.paramsi!=null)return"Paramsi";if(a.paramsd!=null)return"Paramsd"},a.prototype._getTransformFunction=function(a,b){var c="_transform"+this._getOpType(a)+"Against"+this._getOpType(b);return this[c]},a.prototype.name="ftext",a.prototype.create=function(){return[]},a.prototype.apply=function(a,b){var c,d,e;a=j(a);for(d=0,e=b.length;d<e;d++)c=b[d],a=this.applyOp(a,c);return a},a.prototype.applyOp=function(a,b){if(b.ti!=null)return this._applyTextInsert(a,b);if(b.td!=null)return this._applyTextDelete(a,b);if(b.paramsi!=null)return this._applyParamsInsert(a,b);if(b.paramsd!=null)return this._applyParamsDelete(a,b);throw new Error("Unknown operation applied: "+JSON.stringify(b))},a.prototype.transform=function(a,b,c){var d,e,f,g,h,i,k,l=j(a);for(g=0,i=b.length;g<i;g++){e=b[g],f=[];for(h=0,k=l.length;h<k;h++)d=l[h],this.transformOp(f,d,e,c);l=f}return l},a.prototype.transformOp=function(a,b,c,d){var e=this._getTransformFunction(b,c);return e(a,b,c,d)},a.prototype.compose=function(a,b){var c,d=[];return[].splice.apply(d,[0,0].concat(a)),a,[].splice.apply(d,[c=d.length,d.length-c].concat(b)),b,d},a.prototype.isFormattedTextOperation=function(a){return a.td!=null||a.ti!=null||a.paramsd!=null||a.paramsi!=null},a.prototype._invertOp=function(a){var b={};return b.p=a.p,a.params!=null&&(b.params=j(a.params)),a.td!=null&&(b.ti=j(a.td)),a.ti!=null&&(b.td=j(a.ti)),a.paramsd!=null&&(b.paramsi=j(a.paramsd)),a.paramsi!=null&&(b.paramsd=j(a.paramsi)),a.len!=null&&(b.len=j(a.len)),b},a.prototype.invert=function(a){var b,c=function(){var c,d,e=[];for(c=0,d=a.length;c<d;c++)b=a[c],e.push(this._invertOp(b));return e}.call(this);return c.reverse(),c},a}(),k.types||(k.types={}),k.types.ftext=new d,c=function(){function a(a,b,c){this.connection=a,this.name=b,this.shout=t(this.shout,this),this.flush=t(this.flush,this),c||(c={}),this.version=c.v,this.snapshot=c.snaphot,c.type&&this._setType(c.type),this.state="closed",this.autoOpen=!1,this._create=c.create,this.inflightOp=null,this.inflightCallbacks=[],this.inflightSubmittedIds=[],this.pendingOp=null,this.pendingCallbacks=[],this.serverOps={}}return a.prototype._xf=function(a,b){var c,d;return this.type.transformX?this.type.transformX(a,b):(c=this.type.transform(a,b,"left"),d=this.type.transform(b,a,"right"),[c,d])},a.prototype._otApply=function(a,b){var c=this.snapshot;this.snapshot=this.type.apply(this.snapshot,a),this.emit("change",a,c);if(b)return this.emit("remoteop",a,c)},a.prototype._connectionStateChanged=function(a,b){switch(a){case"disconnected":this.state="closed",this.inflightOp&&this.inflightSubmittedIds.push(this.connection.id),this.emit("closed");break;case"ok":this.autoOpen&&this.open();break;case"stopped":typeof this._openCallback=="function"&&this._openCallback(b)}return this.emit(a,b)},a.prototype._setType=function(a){var b,c,d;typeof a=="string"&&(a=r[a]);if(!a||!a.compose)throw new Error("Support for types without compose() is not implemented");this.type=a;if(a.api){d=a.api;for(b in d)c=d[b],this[b]=c;return typeof this._register=="function"?this._register():void 0}return this.provides={}},a.prototype._onMessage=function(a){var b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,v;if(a.open===!0)return this.state="open",this._create=!1,this.created==null&&(this.created=!!a.create),a.type&&this._setType(a.type),a.create?(this.created=!0,this.snapshot=this.type.create()):(this.created!==!0&&(this.created=!1),a.snapshot!==void 0&&(this.snapshot=a.snapshot)),a.v!=null&&(this.version=a.v),this.inflightOp?(h={doc:this.name,op:this.inflightOp,v:this.version},this.inflightSubmittedIds.length&&(h.dupIfSource=this.inflightSubmittedIds),this.connection.send(h)):this.flush(),this.emit("open"),typeof this._openCallback=="function"?this._openCallback(null):void 0;if(a.open===!1)return a.error&&(typeof console!="undefined"&&console!==null&&console.error("Could not open document: "+a.error),this.emit("error",a.error),typeof this._openCallback=="function"&&this._openCallback(a.error)),this.state="closed",this.emit("closed"),typeof this._closeCallback=="function"&&this._closeCallback(),this._closeCallback=null;if(a.op!==null||d!=="Op already submitted"){if(a.op===void 0&&a.v!==void 0||a.op&&(o=a.meta.source,u.call(this.inflightSubmittedIds,o)>=0)){e=this.inflightOp,this.inflightOp=null,this.inflightSubmittedIds.length=0,d=a.error;if(d){this.type.invert?(i=this.type.invert(e),this.pendingOp&&(p=this._xf(this.pendingOp,i),this.pendingOp=p[0],i=p[1]),this._otApply(i,!0)):this.emit("error","Op apply failed ("+d+") and the op could not be reverted"),q=this.inflightCallbacks;for(k=0,m=q.length;k<m;k++)b=q[k],b(d)}else{if(a.v!==this.version)throw new Error("Invalid version from server");this.serverOps[this.version]=e,this.version++,r=this.inflightCallbacks;for(l=0,n=r.length;l<n;l++)b=r[l],b(null,e)}return this.flush()}if(a.op){if(a.v<this.version)return;return a.doc!==this.name?this.emit("error","Expected docName '"+this.name+"' but got "+a.doc):a.v!==this.version?this.emit("error","Expected version "+this.version+" but got "+a.v):(f=a.op,this.serverOps[this.version]=f,c=f,this.inflightOp!==null&&(s=this._xf(this.inflightOp,c),this.inflightOp=s[0],c=s[1]),this.pendingOp!==null&&(t=this._xf(this.pendingOp,c),this.pendingOp=t[0],c=t[1]),this.version++,this._otApply(c,!0))}if(!a.meta)return typeof console!="undefined"&&console!==null?console.warn("Unhandled document message:",a):void 0;v=a.meta,g=v.path,j=v.value;switch(g!=null?g[0]:void 0){case"shout":return this.emit("shout",j);default:return typeof console!="undefined"&&console!==null?console.warn("Unhandled meta op:",a):void 0}}},a.prototype.flush=function(){if(this.connection.state!=="ok"||this.inflightOp!==null||this.pendingOp===null)return;return this.inflightOp=this.pendingOp,this.inflightCallbacks=this.pendingCallbacks,this.pendingOp=null,this.pendingCallbacks=[],this.connection.send({doc:this.name,op:this.inflightOp,v:this.version})},a.prototype.submitOp=function(a,b){return this.type.normalize!=null&&(a=this.type.normalize(a)),this.snapshot=this.type.apply(this.snapshot,a),this.pendingOp!==null?this.pendingOp=this.type.compose(this.pendingOp,a):this.pendingOp=a,b&&this.pendingCallbacks.push(b),this.emit("change",a),setTimeout(this.flush,0)},a.prototype.shout=function(a){return this.connection.send({doc:this.name,meta:{path:["shout"],value:a}})},a.prototype.open=function(a){var b,c=this;this.autoOpen=!0;if(this.state!=="closed")return;return b={doc:this.name,open:!0},this.snapshot===void 0&&(b.snapshot=null),this.type&&(b.type=this.type.name),this.version!=null&&(b.v=this.version),this._create&&(b.create=!0),this.connection.send(b),this.state="opening",this._openCallback=function(b){return c._openCallback=null,typeof a=="function"?a(b):void 0}},a.prototype.close=function(a){return this.autoOpen=!1,this.state==="closed"?typeof a=="function"?a():void 0:(this.connection.send({doc:this.name,open:!1}),this.state="closed",this.emit("closing"),this._closeCallback=a)},a}(),e.mixin(c),k.Doc=c,r||(r=k.types);if(!window.BCSocket)throw new Error("Must load browserchannel before this library");a=window.BCSocket,b=function(){function b(b){var c=this;this.docs={},this.state="connecting",this.socket=new a(b,{reconnect:!0}),this.socket.onmessage=function(a){var b;if(a.auth===null)return c.lastError=a.error,c.disconnect(),c.emit("connect failed",a.error);if(a.auth){c.id=a.auth,c.setState("ok");return}return b=a.doc,b!==void 0?c.lastReceivedDoc=b:a.doc=b=c.lastReceivedDoc,c.docs[b]?c.docs[b]._onMessage(a):typeof console!="undefined"&&console!==null?console.error("Unhandled message",a):void 0},this.connected=!1,this.socket.onclose=function(a){c.setState("disconnected",a);if(a==="Closed"||a==="Stopped by server")return c.setState("stopped",c.lastError||a)},this.socket.onerror=function(a){return c.emit("error",a)},this.socket.onopen=function(){return c.lastError=c.lastReceivedDoc=c.lastSentDoc=null,c.setState("handshaking")},this.socket.onconnecting=function(){return c.setState("connecting")}}return b.prototype.setState=function(a,b){var c,d,e,f;if(this.state===a)return;this.state=a,a==="disconnected"&&delete this.id,this.emit(a,b),e=this.docs,f=[];for(d in e)c=e[d],f.push(c._connectionStateChanged(a,b));return f},b.prototype.send=function(a){var b=a.doc;return b===this.lastSentDoc?delete a.doc:this.lastSentDoc=b,this.socket.send(a)},b.prototype.disconnect=function(){return this.socket.close()},b.prototype.makeDoc=function(a,b,d){var e,f=this;if(this.docs[a])throw new Error("Doc "+a+" already open");return e=new c(this,a,b),this.docs[a]=e,e.open(function(b){return b&&delete f.docs[a],d(b,b?void 0:e)})},b.prototype.openExisting=function(a,b){var c;return this.state==="stopped"?b("connection closed"):this.docs[a]?b(null,this.docs[a]):c=this.makeDoc(a,{},b)},b.prototype.open=function(a,b,c){var d;if(this.state==="stopped")return c("connection closed");typeof b=="function"&&(c=b,b="text"),c||(c=function(){}),typeof b=="string"&&(b=r[b]);if(!b)throw new Error("OT code for document type missing");if(a==null)throw new Error("Server-generated random doc names are not currently supported");if(this.docs[a]){d=this.docs[a],d.type===b?c(null,d):c("Type mismatch",d);return}return this.makeDoc(a,{create:!0,type:b.name},c)},b}(),e.mixin(b),k.Connection=b,k.open=function(){var a={},c=function(c){var d,e,f;return f=window.location,c==null&&(c=""+f.protocol+"//"+f.host+"/channel"),a[c]||(d=new b(c),e=function(){return delete a[c]},d.on("disconnecting",e),d.on("connect failed",e),a[c]=d),a[c]},d=function(a){var b,c,d=0,e=a.docs;for(c in e)b=e[c],(b.state!=="closed"||b.autoOpen)&&d++;if(d===0)return a.disconnect()};return function(a,b,e,f){var g;return typeof e=="function"&&(f=e,e=null),g=c(e),g.numDocs++,g.open(a,b,function(a,b){return a?(f(a),d(g)):(b.on("closed",function(){return d(g)}),f(null,b))}),g.on("connect failed"),g}}()})).call(this)