# tihqx Module

## Description

This is a module I made for a personal project that had to download and show remote images with no retina version. I decided to upscale them with **hq2x**, a fast, high-quality 2x magnification filter, used by lot 8/16-bit console emulators -demo images can be found [here](http://spacy51.sp.funpic.de/hq_filters/hq2x.html)-. Maybe there're many other ways to handle this, but hey! I love these things.

Just:

```js
var hqx = require('net.iamyellow.tihqx'),
window = Ti.UI.createWindow({
	backgroundColor: 'red'
});

// as a view
var image = require('net.iamyellow.tihqx').createView({
	top: 0, left: 0,
	image: 'hqx_orig.png'
}),
// base64 encoded images
image2 = require('net.iamyellow.tihqx').createView({
	top: 0, right: 0,
	base64: 'data:;base64,BASE64_ENCODED_IMAGE_STRING'
});
window.add(image);
window.add(image2);

// using a blob
var src = Ti.UI.createImageView({
	image: 'hqx_orig.png'
}),
dst = Ti.UI.createImageView({
	bottom: 0, left: 0,
	image: hqx.get2xBlob(src.toBlob())
});
window.add(dst);

window.open();```

## Author

jordi domenech
jordi@iamyellow.net
http://iamyellow.net
@iamyellow2

## Feedback and Support

jordi@iamyellow.net

## License

Copyright 2012 jordi domenech <jordi@iamyellow.net>
Apache License, Version 2.0