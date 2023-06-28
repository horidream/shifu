
const targetMap = new WeakMap()

function isHTMLElement(target) {
	return target instanceof HTMLElement;
}


export function observe(targetNode, property, cb) {
    let selector = targetNode;
    if(!isHTMLElement(targetNode) && typeof targetNode === "string"){
        targetNode = document.querySelector(targetNode)
    }
    if(!targetNode) return;
    if(Object.prototype.toString.call(targetNode).slice(8, -1) === 'Array'){
        return targetNode.map(item=>{
            observe(item, property, cb);
        })
    }
    try{
        targetMap.get(targetNode)?.disconnect();
        targetMap.delete(targetNode);
    }catch(e){}
	var observer = new MutationObserver(function (mutationsList, observer) {
		for (let mutation of mutationsList) {
			if (
				mutation.type === "attributes" &&
				mutation.attributeName === property
			) {
				var targetClassList = targetNode.classList;
				cb(targetNode, selector)
				break; // If you are only interested in class changes, exit the loop early
			}
		}
	});

	// Configuration of the observer:
	var config = { attributes: true, childList: false, subtree: false };

	// Start observing the target node for configured mutations
	observer.observe(targetNode, config);
    targetMap.set(observer);
    return observer;
}
