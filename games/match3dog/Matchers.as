package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class Matchers extends MovieClip
	{
		var isFading:Boolean=false;
		var tileLevel:int;
		
		public function Matchers():void
		{
			if(stage)
			{
				init();
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, initEvent);
			}
		}
		function initEvent(e:Event):void
		{
			init();
		}
		function init():void
		{
			changeTile();
		}
		public function changeTile():void
		{
			if (tileLevel<totalFrames)
			{
				gotoAndStop(int(Math.random()*tileLevel)+1);
			}
			else
			{
				gotoAndStop(int(Math.random()*totalFrames)+1);
			}
		}
	}
}