I hacked up a simple "slideshow" app, using some [joystick event reading code](https://gist.github.com/jasonwhite/c5b2048c15993d285130), which listens for controller button presses and outputs the corresponding video (using "[static ARMHF ffmpeg binary](https://johnvansickle.com/ffmpeg/)") or image (using "[decodepng](https://github.com/DanTheMan827/decodepng/blob/ac7f36a559396b2acae2bec3302078ac49b9eb1a/decodepng.c)").

Videos are shown first and you're better off having a video and image with the same filename to avoid the video ending on a black screen.

Using the left and right arrow keys ignores videos - making it easier to move back or forward through slides quickly while the A and B buttons navigate and play videos. Pressing "select" twice on the controller exits the slideshow app (presumably back to the main menu).
