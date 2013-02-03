how run build file:
	
	download FLEX from http://www.adobe.com/devnet/flex/flex-sdk-download.html
	set environment variable FLEX_HOME to flex installation directory
	
	download ANT from http://ant.apache.org/bindownload.cgi
	unpack it into directory that does not contain spaces (!)
	add ANT installation binaries directory to your PATH variable
	
	for instance:
		FLEX_HOME E:\FlashDevelop\Tools\flexsdk
		Path      (...)C:\Java\jdk1.6.0_27\bin;E:\ant\apache-ant-1.8.3\bin
	
use ANT via command line:
	
	C:\>ant -buildfile "F:\SaladoPlayer\ant\build.xml" "SaladoPlayer"
	(here SaladoPlayer is name of task defined in build.xml file)
	
when using FlashDevelop:
	
	download plugin http://code.google.com/p/fd-ant-plugin/downloads/list
	place unpacked *.dll in Flashdevelop plugins directory
	in "Program Settings" configure AntPlugin by pointing to ANT installation directory
	restart Flashdevelop, open "Ant window" and point to build.xml file
	
for more details see comments inside build.xml file