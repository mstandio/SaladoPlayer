package test.com.panozona.player.manager.utils.configuration {
	
	import com.panozona.player.component.*;
	import com.panozona.player.manager.data.actions.ActionData;
	import com.panozona.player.manager.data.actions.FunctionDataTarget;
	import com.panozona.player.manager.utils.configuration.*;
	import com.robertpenner.easing.*;
	import flash.events.*;
	import flexunit.framework.*;
	import org.hamcrest.*;
	
	public class ManagerDataParserXMLActions extends com.panozona.player.manager.utils.configuration.ManagerDataParserXML{
		
		[Test]
		public function parseActionContentPlainStructure():void {
			var actionData:ActionData = new ActionData("a");
			parseActionContent(actionData, "owna.nama();ownb.namb();ownc.namc()");
			
			Assert.assertEquals(3, actionData.functions.length);
			
			Assert.assertFalse(actionData.functions[0] is FunctionDataTarget);
			Assert.assertFalse(actionData.functions[1] is FunctionDataTarget);
			Assert.assertFalse(actionData.functions[2] is FunctionDataTarget);
			
			Assert.assertStrictlyEquals("owna", actionData.functions[0].owner);
			Assert.assertStrictlyEquals("nama", actionData.functions[0].name);
			
			Assert.assertStrictlyEquals("ownb", actionData.functions[1].owner);
			Assert.assertStrictlyEquals("namb", actionData.functions[1].name);
			
			Assert.assertStrictlyEquals("ownc", actionData.functions[2].owner);
			Assert.assertStrictlyEquals("namc", actionData.functions[2].name);
		}
		
		[Test]
		public function parseActionContentPlainString():void {
			var actionData:ActionData = new ActionData("a");
			parseActionContent(actionData, "owna.nama(foo);ownb.namb([bar]);ownc.namc(foo,[bar])");
			
			Assert.assertStrictlyEquals("foo", actionData.functions[0].args[0]);
			Assert.assertStrictlyEquals("bar", actionData.functions[1].args[0]);
			Assert.assertStrictlyEquals("foo", actionData.functions[2].args[0]);
			Assert.assertStrictlyEquals("bar", actionData.functions[2].args[1]);
		}
		
		[Test]
		public function parseActionContentPlainNumber():void {
			var actionData:ActionData = new ActionData("a");
			parseActionContent(actionData, "owna.nama(-12.12);ownb.namb(#ff00ff);ownc.namc(NaN)");
			
			Assert.assertStrictlyEquals(-12.12, actionData.functions[0].args[0]);
			Assert.assertStrictlyEquals(0xff00ff, actionData.functions[1].args[0]);
			Assert.assertTrue(isNaN(actionData.functions[2].args[0]));
		}
		
		[Test]
		public function parseActionContentPlainBoolean():void {
			var actionData:ActionData = new ActionData("a");
			parseActionContent(actionData, "owna.nama(true);ownb.namb(false);ownc.namc(true,false)");
			
			Assert.assertStrictlyEquals(true, actionData.functions[0].args[0]);
			Assert.assertStrictlyEquals(false, actionData.functions[1].args[0]);
			Assert.assertStrictlyEquals(true, actionData.functions[2].args[0]);
			Assert.assertStrictlyEquals(false, actionData.functions[2].args[1]);
		}
		
		[Test]
		public function parseActionContentPlainFunction():void {
			var actionData:ActionData = new ActionData("a");
			parseActionContent(actionData, "owna.nama(Linear.easeNone);ownb.namb(Linear.easeNone,Linear.easeIn)");
			
			Assert.assertStrictlyEquals(Linear.easeNone, actionData.functions[0].args[0]);
			Assert.assertStrictlyEquals(Linear.easeNone, actionData.functions[1].args[0]);
			Assert.assertStrictlyEquals(Linear.easeIn, actionData.functions[1].args[1]);
		}
		
		[Test]
		public function parseActionContentTargetStructure():void {
			var actionData:ActionData = new ActionData("a");
			parseActionContent(actionData, "owna[targa].nama();ownb[targb].namb();ownc[targc].namc()");
			Assert.assertEquals(3, actionData.functions.length);
			Assert.assertTrue(actionData.functions[0] is FunctionDataTarget);
			Assert.assertTrue(actionData.functions[1] is FunctionDataTarget);
			Assert.assertTrue(actionData.functions[2] is FunctionDataTarget);
			
			Assert.assertStrictlyEquals("owna", actionData.functions[0].owner);
			Assert.assertStrictlyEquals("nama", actionData.functions[0].name);
			Assert.assertStrictlyEquals("targa", (actionData.functions[0] as FunctionDataTarget).target);
			
			Assert.assertStrictlyEquals("ownb", actionData.functions[1].owner);
			Assert.assertStrictlyEquals("namb", actionData.functions[1].name);
			Assert.assertStrictlyEquals("targb", (actionData.functions[1] as FunctionDataTarget).target);
			
			Assert.assertStrictlyEquals("ownc", actionData.functions[2].owner);
			Assert.assertStrictlyEquals("namc", actionData.functions[2].name);
			Assert.assertStrictlyEquals("targc", (actionData.functions[2] as FunctionDataTarget).target);
		}
		
		[Test]
		public function parseActionContentTargetString():void {
			var actionData:ActionData = new ActionData("a");
			parseActionContent(actionData, "owna[targa].nama(foo);ownb[targb].namb([bar]);ownc[targc].namc(foo,[bar])");
			
			Assert.assertStrictlyEquals("foo", actionData.functions[0].args[0]);
			Assert.assertStrictlyEquals("bar", actionData.functions[1].args[0]);
			Assert.assertStrictlyEquals("foo", actionData.functions[2].args[0]);
			Assert.assertStrictlyEquals("bar", actionData.functions[2].args[1]);
		}
		
		[Test]
		public function parseActionContentTargetNumber():void {
			var actionData:ActionData = new ActionData("a");
			parseActionContent(actionData, "owna[targa].nama(-12.12);ownb[targb].namb(#ff00ff);ownc[targc].namc(NaN)");
			
			Assert.assertStrictlyEquals(-12.12, actionData.functions[0].args[0]);
			Assert.assertStrictlyEquals(0xff00ff, actionData.functions[1].args[0]);
			Assert.assertTrue(isNaN(actionData.functions[2].args[0]));
		}
		
		[Test]
		public function parseActionContentTargetBoolean():void {
			var actionData:ActionData = new ActionData("a");
			parseActionContent(actionData, "owna[targa].nama(true);ownb[targb].namb(false);ownc[targc].namc(true,false)");
			
			Assert.assertStrictlyEquals(true, actionData.functions[0].args[0]);
			Assert.assertStrictlyEquals(false, actionData.functions[1].args[0]);
			Assert.assertStrictlyEquals(true, actionData.functions[2].args[0]);
			Assert.assertStrictlyEquals(false, actionData.functions[2].args[1]);
		}
		
		[Test]
		public function parseActionContentTargetFunction():void {
			var actionData:ActionData = new ActionData("a");
			parseActionContent(actionData, "owna[targa].nama(Linear.easeNone);ownb[targb].namb(Linear.easeNone,Linear.easeIn)");
			
			Assert.assertStrictlyEquals(Linear.easeNone, actionData.functions[0].args[0]);
			Assert.assertStrictlyEquals(Linear.easeNone, actionData.functions[1].args[0]);
			Assert.assertStrictlyEquals(Linear.easeIn, actionData.functions[1].args[1]);
		}
		
		[Test]
		public function parseActionContentMixedStructure():void {
			var actionData:ActionData = new ActionData("a");
			parseActionContent(actionData, "owna.nama();ownb[targb].namb();ownc.namc()");
			
			Assert.assertEquals(3, actionData.functions.length);
			
			Assert.assertFalse(actionData.functions[0] is FunctionDataTarget);
			Assert.assertTrue(actionData.functions[1] is FunctionDataTarget);
			Assert.assertFalse(actionData.functions[2] is FunctionDataTarget);
			
			Assert.assertStrictlyEquals("owna", actionData.functions[0].owner);
			Assert.assertStrictlyEquals("nama", actionData.functions[0].name);
			
			Assert.assertStrictlyEquals("ownb", actionData.functions[1].owner);
			Assert.assertStrictlyEquals("namb", actionData.functions[1].name);
			Assert.assertStrictlyEquals("targb", (actionData.functions[1] as FunctionDataTarget).target);
			
			Assert.assertStrictlyEquals("ownc", actionData.functions[2].owner);
			Assert.assertStrictlyEquals("namc", actionData.functions[2].name);
		}
		
		[Test]
		public function parseActionContentMixedString():void {
			var actionData:ActionData = new ActionData("a");
			parseActionContent(actionData, "owna.nama(foo);ownb[targb].namb([bar]);ownc.namc(foo,[bar])");
			
			Assert.assertStrictlyEquals("foo", actionData.functions[0].args[0]);
			Assert.assertStrictlyEquals("bar", actionData.functions[1].args[0]);
			Assert.assertStrictlyEquals("foo", actionData.functions[2].args[0]);
			Assert.assertStrictlyEquals("bar", actionData.functions[2].args[1]);
		}
		
		[Test]
		public function parseActionContentMixedNumber():void {
			var actionData:ActionData = new ActionData("a");
			parseActionContent(actionData, "owna.nama(-12.12);ownb[targb].namb(#ff00ff);ownc.namc(NaN)");
			
			Assert.assertStrictlyEquals(-12.12, actionData.functions[0].args[0]);
			Assert.assertStrictlyEquals(0xff00ff, actionData.functions[1].args[0]);
			Assert.assertTrue(isNaN(actionData.functions[2].args[0]));
		}
		
		[Test]
		public function parseActionContentMixedBoolean():void {
			var actionData:ActionData = new ActionData("a");
			parseActionContent(actionData, "owna.nama(true);ownb[targb].namb(false);ownc.namc(true,false)");
			
			Assert.assertStrictlyEquals(true, actionData.functions[0].args[0]);
			Assert.assertStrictlyEquals(false, actionData.functions[1].args[0]);
			Assert.assertStrictlyEquals(true, actionData.functions[2].args[0]);
			Assert.assertStrictlyEquals(false, actionData.functions[2].args[1]);
		}
		
		[Test]
		public function parseActionContentMixedFunction():void {
			var actionData:ActionData = new ActionData("a");
			parseActionContent(actionData, "owna.nama(Linear.easeNone);ownb[targb].namb(Linear.easeNone,Linear.easeIn)");
			
			Assert.assertStrictlyEquals(Linear.easeNone, actionData.functions[0].args[0]);
			Assert.assertStrictlyEquals(Linear.easeNone, actionData.functions[1].args[0]);
			Assert.assertStrictlyEquals(Linear.easeIn, actionData.functions[1].args[1]);
		}
		
		[Test]
		public function parseActionContentWarning():void {
			var callCount : int = 0;
			addEventListener(ConfigurationEvent.WARNING, function(event:Event):void{callCount++;});
			
			// wrong foramt of action content
			parseActionContent(new ActionData("a"),"owna.nama");
			parseActionContent(new ActionData("b"),"owna.nama;ownb.namb"); // dispatches two events 
			parseActionContent(new ActionData("c"),"owna.nama,ownb.namb");
			parseActionContent(new ActionData("d"), "owna.nama;"); // dispathes two events
			parseActionContent(new ActionData("e"), "");
			
			// wrong format of function
			parseActionContent(new ActionData("f"), "owna.nama([foo;bar])"); // dispatches two events 
			
			// wrong format of function (target)
			parseActionContent(new ActionData("h"), "owna.targa.nama([foo;bar])"); // dispatches two events 
			
			Assert.assertEquals(11, callCount);
		}
		
		[Test]
		public function parseActionsStructure():void {
			var actionsData:Vector.<ActionData> = new Vector.<ActionData>();
			var nodeXML:XML = new XML(
				"<root>" +
				"<action id=\"act1\" content=\"owna.nama(NaN,false,[foo]);ownb[targb].namb(foo,Linear.easeNone)\"/>" + 
				"<action id=\"act2\" content=\"ownc.namc(-12.12,Linear.easeNone);ownd[targd].namd(#00ff00,bar)\"/>" +
				"</root>");
			parseActions(actionsData, nodeXML);
			
			Assert.assertEquals(2, actionsData.length);
			Assert.assertEquals(2, actionsData[0].functions.length);
			Assert.assertEquals(2, actionsData[1].functions.length);
			
			Assert.assertStrictlyEquals("act1", actionsData[0].id);
			
			Assert.assertStrictlyEquals("owna", actionsData[0].functions[0].owner);
			Assert.assertStrictlyEquals("nama", actionsData[0].functions[0].name);
			Assert.assertTrue(isNaN(actionsData[0].functions[0].args[0]));
			Assert.assertStrictlyEquals(false, actionsData[0].functions[0].args[1]);
			Assert.assertStrictlyEquals("foo", actionsData[0].functions[0].args[2]);
			
			Assert.assertStrictlyEquals("ownb", actionsData[0].functions[1].owner);
			Assert.assertStrictlyEquals("namb", actionsData[0].functions[1].name);
			Assert.assertStrictlyEquals("targb", (actionsData[0].functions[1] as FunctionDataTarget).target);
			Assert.assertStrictlyEquals("foo", actionsData[0].functions[1].args[0]);
			Assert.assertStrictlyEquals(Linear.easeNone, actionsData[0].functions[1].args[1]);
			
			Assert.assertStrictlyEquals("act2", actionsData[1].id);
			
			Assert.assertStrictlyEquals("ownc", actionsData[1].functions[0].owner);
			Assert.assertStrictlyEquals("namc", actionsData[1].functions[0].name);
			Assert.assertStrictlyEquals(-12.12, actionsData[1].functions[0].args[0]);
			Assert.assertStrictlyEquals(Linear.easeNone, actionsData[1].functions[0].args[1]);
			
			Assert.assertStrictlyEquals("ownd", actionsData[1].functions[1].owner);
			Assert.assertStrictlyEquals("namd", actionsData[1].functions[1].name);
			Assert.assertStrictlyEquals("targd", (actionsData[1].functions[1] as FunctionDataTarget).target);
			Assert.assertStrictlyEquals(0x00ff00, actionsData[1].functions[1].args[0]);
			Assert.assertStrictlyEquals("bar", actionsData[1].functions[1].args[1]);
		}
		
		[Test]
		public function parseActionsWarning():void {
			var callCount : int = 0;
			addEventListener(ConfigurationEvent.WARNING, function(event:Event):void{callCount++;});
			
			// action id missing
			parseActions(new Vector.<ActionData>(), new XML("<root><action content=\"foo.bar()\"/></root>"));
			
			// action content missing
			parseActions(new Vector.<ActionData>(), new XML("<root><action id=\"act1\"/></root>"));
			
			// action id wrong format
			parseActions(new Vector.<ActionData>(), new XML("<root><action id=\"12\" content=\"foo.bar()\"/></root>"));
			
			// action unknown attrubute
			parseActions(new Vector.<ActionData>(), new XML("<root><action id=\"act1\" functions=\"foo.bar()\"/></root>"));
			
			Assert.assertEquals(4, callCount);
		}
	}
}