var window = Ti.UI.createWindow({
	backgroundColor: 'red'
});

var image = require('net.iamyellow.tihqx').createView({
	top: 0, left: 0,
	image: 'hqx_orig.png'
}),
image2 = Ti.UI.createImageView({
	top: 0, right: 0,
	image: 'hqx_orig.png'
});
window.add(image);
window.add(image2);

window.open();