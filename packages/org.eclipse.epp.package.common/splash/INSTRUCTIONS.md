# About Splash Screen

### Interact with Eclipse Foundation for new splash screen series

**When:** after the March release

Although, Eclipse IDE packages are shipped every 3 months, one release a year (usually in June) receives addition marketing support. This usually include a new main website and a new splashscreen. The Community must request the new splashscreen as early as possible before June (ideally after the March release) via a Bugzilla ticket addressed to Eclipse Foundation. If you open this ticket, make sure Eclipse Foundation marketing people are registered as CC.

When ready, the Eclipse Foundation marketing team will submit some splashscreen, sometimes asking for feedback when multiple splash screens are competing. When the final splashscreen is selected, the community has to ask for the variations of this splashscreen: some saying just "Eclipse" (for the Platform artifacts) and some saying "Eclipse IDE" (for the EPP packages), and the 4 variations for each quarterly release (202x-06, 202x-09, 202x-12, 202(x+1)-03).

### Copy splash screen series into `org.eclipse.epp.package.common/splash/`

Once the Foundation and community agree on a splash screen, some EPP contributor must copy the new splash screen into `org.eclipse.epp.package.common/splash/` for further usage in EPP.

Some raw image files are welcome, but as those artifacts may have to be changed unexpectedly, keeping the "image project" files (Photoshop or Illustrator files) in the repository can also help later.

### Changing EPP splashscreen

The splash screen needs to be an (approximately) 450x300 pixels .bmp file, 24-bits RGB (maybe other depth work too, but it's not tested), **without color space information** (some SWT bug). To produce it, if the initial splash screens aren't of that form (they're usually .jpg files), open the desired splash screen variation file from the `org.eclipse.epp.package.common/splash/` folder in Gimp, resize it to approximately 450x300 with *Image > Scale*, then *File > Export* it: choose the location `org.eclipse.epp.package.common/splash.bmp`, and in the Export options, tick *Compatibility Options > Do not write color space information*. Apply.

Then, commit the change locally, test it by building whichever EPP package via command-line and then starting this package. The new splash screen should be in place. Then, push the change to Gerrit.