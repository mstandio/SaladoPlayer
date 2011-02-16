package test.com.panozona.player.manager.utils.loading {
	
	import com.panozona.player.manager.events.*;
	import com.panozona.player.manager.utils.loading.*;
	import flexunit.framework.Assert;
	import org.flexunit.async.Async;
	
	public class LoadablesLoaderAsync{
		
		protected var loadablesLoader:LoadablesLoader;
		protected var loadables:Vector.<ILoadable>;
		protected var dummyLoadables:Vector.<DummyLoadable>;
		
		protected var loadedCounter:Number;
		protected var lostCounter:Number;
		
		[Before]
		public function setUp():void {
			loadablesLoader = new LoadablesLoader();
			loadables = new Vector.<ILoadable>();
			dummyLoadables = new Vector.<DummyLoadable>();
			loadedCounter = 0;
			lostCounter = 0;
		}
		
		[After]
		public function tearDown():void {
			loadablesLoader.abort();
		}
		
		[Test(async)]
		public function nothingToLoad():void {
			var asyncHandler:Function = Async.asyncHandler( this, handleFinishedNothing, 100, null, handleTimeoutNothing);
			loadablesLoader.addEventListener(LoadLoadableEvent.FINISHED, asyncHandler, false, 0, true);
			loadablesLoader.load(loadables);
		}
		protected function handleFinishedNothing(event:LoadLoadableEvent, passThroughData:Object):void {
			Assert.assertEquals(LoadLoadableEvent.FINISHED, event.type);
			Assert.assertEquals(0, lostCounter);
			Assert.assertEquals(0, loadedCounter);
		}
		protected function handleTimeoutNothing(passThroughData:Object):void {
			Assert.fail( "Timeout reached before event");
		}
		
		[Test(async)]
		public function allPathsCorrect():void {
			var asyncHandler:Function = Async.asyncHandler( this, handleFinishedCorrect, 500, null, handleTimeoutCorrect);
			loadablesLoader.addEventListener(LoadLoadableEvent.FINISHED, asyncHandler, false, 0, true);
			loadablesLoader.addEventListener(LoadLoadableEvent.LOADED, function(e:LoadLoadableEvent):void {loadedCounter ++ }, false, 0, true);
			loadablesLoader.addEventListener(LoadLoadableEvent.LOST, function(e:LoadLoadableEvent):void{lostCounter ++}, false, 0, true);
			
			loadables.push(new DummyLoadable("assets/blue.png"));
			loadables.push(new DummyLoadable("assets/red.jpg"));
			loadables.push(new DummyLoadable("assets/yellow.gif"));
			loadablesLoader.load(loadables);
		}
		protected function handleFinishedCorrect(event:LoadLoadableEvent, passThroughData:Object):void {
			Assert.assertEquals(LoadLoadableEvent.FINISHED, event.type);
			Assert.assertEquals(0, lostCounter);
			Assert.assertEquals(3, loadedCounter);
		}
		protected function handleTimeoutCorrect(passThroughData:Object):void {
			Assert.fail( "Timeout reached before event");
		}
		
		[Test(async)]
		public function allPathsCorrect2():void {
		var asyncHandler:Function = Async.asyncHandler( this, handleFinishedCorrect2, 500, null, handleTimeoutCorrect2);
			loadablesLoader.addEventListener(LoadLoadableEvent.FINISHED, asyncHandler, false, 0, true);
			loadablesLoader.addEventListener(LoadLoadableEvent.LOADED, function(e:LoadLoadableEvent):void {loadedCounter ++ }, false, 0, true);
			loadablesLoader.addEventListener(LoadLoadableEvent.LOST, function(e:LoadLoadableEvent):void{lostCounter ++}, false, 0, true);
			
			dummyLoadables.push(new DummyLoadable("assets/blue.png"));
			dummyLoadables.push(new DummyLoadable("assets/red.jpg"));
			dummyLoadables.push(new DummyLoadable("assets/yellow.gif"));
			loadablesLoader.load(Vector.<ILoadable>(dummyLoadables));
		}
		protected function handleFinishedCorrect2(event:LoadLoadableEvent, passThroughData:Object):void {
			Assert.assertEquals(LoadLoadableEvent.FINISHED, event.type);
			Assert.assertEquals(0, lostCounter);
			Assert.assertEquals(3, loadedCounter);
		}
		protected function handleTimeoutCorrect2(passThroughData:Object):void {
			Assert.fail( "Timeout reached before event");
		}
		
		[Test(async)]
		public function pathsInvalid():void {
			var asyncHandler:Function = Async.asyncHandler(this, handleFinishedPathsInvalid, 500, null, handleTimeoutPathsInvalid);
			loadablesLoader.addEventListener(LoadLoadableEvent.FINISHED, asyncHandler, false, 0, true);
			loadablesLoader.addEventListener(LoadLoadableEvent.LOADED, function(e:LoadLoadableEvent):void {loadedCounter ++ }, false, 0, true);
			loadablesLoader.addEventListener(LoadLoadableEvent.LOST, function(e:LoadLoadableEvent):void{lostCounter ++}, false, 0, true);
			
			loadables.push(new DummyLoadable("assets/invalid.png"));
			loadables.push(new DummyLoadable("assets/green.bmp")); // unsupported type
			loadables.push(new DummyLoadable("assets/red.jpg"));
			loadables.push(new DummyLoadable("assets/yellow.gif"));
			loadablesLoader.load(loadables);
		}
		protected function handleFinishedPathsInvalid(event:LoadLoadableEvent, passThroughData:Object):void {
			Assert.assertEquals(LoadLoadableEvent.FINISHED, event.type);
			Assert.assertEquals(2, lostCounter);
			Assert.assertEquals(2, loadedCounter);
		}
		protected function handleTimeoutPathsInvalid(passThroughData:Object):void {
			Assert.fail( "Timeout reached before event");
		}
	}
}

import com.panozona.player.manager.utils.loading.*;

class DummyLoadable implements ILoadable {
	
	private var _path:String;
	
	public function DummyLoadable(path:String):void {
		_path = path;
	}
	
	public function get path():String {
		return _path;
	}
}