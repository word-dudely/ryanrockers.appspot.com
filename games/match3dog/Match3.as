package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import fl.motion.easing.Back;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.URLRequestMethod;
	import flash.net.URLLoaderDataFormat;
	import flash.display.StageDisplayState;
	import flash.net.SharedObject;
	
	public class Match3 extends MovieClip
	{
		var numColumns:int=13;
		var numRows:int=12;
		var rowArray:Array=new Array();
		var columnArray0:Array=new Array();
		var columnArray1:Array=new Array();
		var columnArray2:Array=new Array();
		var columnArray3:Array=new Array();
		var columnArray4:Array=new Array();
		var columnArray5:Array=new Array();
		var columnArray6:Array=new Array();
		var columnArray7:Array=new Array();
		var columnArray8:Array=new Array();
		var columnArray9:Array=new Array();
		var columnArray10:Array=new Array();
		var columnArray11:Array=new Array();
		var i:int;
		var i2:int;
		var xOffset:Number=25;
		var yOffset:Number=25;
		var score:Number=0;
		var isFading:Boolean=false;
		var rowClearing:Boolean=false;
		var levelMark:Number;
		var levelMarker:Number=50;
		var currentLevel:int;
		var initTileLevel:int=6;
		var numMatch5s:int;
		var numMatch4s:int;
		var hintArray:Array=new Array();
		var gameOverState:Boolean;
		var highScoreXML:XML;
		var highScoreSO:SharedObject=SharedObject.getLocal("match3Dog");
		var highScore:int=highScoreSO.data.highScore;
		
		public function Match3():void
		{
			if (stage)
			{
				init();
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE,initEvent);
			}
		}
		function initEvent(e:Event):void
		{
			init();
		}
		function init():void
		{
			restartConfirm.visible=false;
			getHighScores();
			var matcher:Matchers;
			//layout the pieces, fill the arrays
			for (i=0;i<numRows;i++)
			{
				for(i2=0;i2<numColumns;i2++)
				{
					matcher=new(Matchers);
					matcher.x=(i2*50)+xOffset;
					matcher.y=(i*50)+yOffset;
					matcher.addEventListener(MouseEvent.MOUSE_DOWN, matcherMDown);
					matcher.addEventListener(MouseEvent.MOUSE_UP, matcherMUp);
					matcher.tileLevel=initTileLevel;
					this["columnArray"+i].push(matcher);
					addChild(matcher);
				}
				rowArray.push(this["columnArray"+i]);
			}
			dePair();
			scoreField.text=""+score;
			restartBtn.addEventListener(MouseEvent.MOUSE_DOWN, btnMDown);
			restartBtn.addEventListener(MouseEvent.MOUSE_OVER, btnMOver);
			restartBtn.addEventListener(MouseEvent.MOUSE_OUT, btnMOut);
			restartBtn.addEventListener(MouseEvent.MOUSE_UP, restartBtnMUp);
			restartBtn.gotoAndStop("idle");
			hintBtn.addEventListener(MouseEvent.MOUSE_DOWN, btnMDown);
			hintBtn.addEventListener(MouseEvent.MOUSE_OVER, btnMOver);
			hintBtn.addEventListener(MouseEvent.MOUSE_OUT, btnMOut);
			hintBtn.addEventListener(MouseEvent.MOUSE_UP, hintBtnUp);
			hintBtn.gotoAndStop("idle");
			gameOver.enterNameMC.submitBtn.addEventListener(MouseEvent.MOUSE_DOWN, btnMDown);
			gameOver.enterNameMC.submitBtn.addEventListener(MouseEvent.MOUSE_OVER, btnMOver);
			gameOver.enterNameMC.submitBtn.addEventListener(MouseEvent.MOUSE_OUT, btnMOut);
			gameOver.enterNameMC.submitBtn.addEventListener(MouseEvent.MOUSE_UP, submitBtnMUp);
			gameOver.enterNameMC.submitBtn.gotoAndStop("idle");
			/*topDogsBtn.addEventListener(MouseEvent.MOUSE_DOWN, btnMDown);
			topDogsBtn.addEventListener(MouseEvent.MOUSE_OVER, btnMOver);
			topDogsBtn.addEventListener(MouseEvent.MOUSE_OUT, btnMOut);
			topDogsBtn.addEventListener(MouseEvent.MOUSE_UP, topDogsBtnUp);
			topDogsBtn.gotoAndStop("idle");*/
			topDogsBtn.visible=false;
			restartConfirm.yesBtn.addEventListener(MouseEvent.MOUSE_DOWN, btnMDown);
			restartConfirm.yesBtn.addEventListener(MouseEvent.MOUSE_OVER, btnMOver);
			restartConfirm.yesBtn.addEventListener(MouseEvent.MOUSE_OUT, btnMOut);
			restartConfirm.yesBtn.addEventListener(MouseEvent.MOUSE_UP, restartYesBtnUp);
			restartConfirm.yesBtn.gotoAndStop("idle");
			restartConfirm.noBtn.addEventListener(MouseEvent.MOUSE_DOWN, btnMDown);
			restartConfirm.noBtn.addEventListener(MouseEvent.MOUSE_OVER, btnMOver);
			restartConfirm.noBtn.addEventListener(MouseEvent.MOUSE_OUT, btnMOut);
			restartConfirm.noBtn.addEventListener(MouseEvent.MOUSE_UP, restartNoBtnUp);
			restartConfirm.noBtn.gotoAndStop("idle");
			highScoreList.closeBtn.addEventListener(MouseEvent.CLICK, highScoreCloseBtnClick);
			fullscreenBtn.addEventListener(MouseEvent.CLICK, fullscreenBtnClick);
			addEventListener(Event.ENTER_FRAME, enterFrameEvent);
			levelMark=levelMarker;
			currentLevel=0;
			numMatch5s=0;
			numMatch4s=0;
			match4field.text=""+numMatch4s;
			match5field.text=""+numMatch5s;
			levelField.text=""+currentLevel;
			highScoreField.text=""+highScore;
			gameOverState=false;
			highScoreList.visible=false;
			gameOver.enterNameMC.inputName.needsSoftKeyboard=true;
		}
		function dePair()
		{
			//go through the arrays checking if the touching upper and left tiles match the current one, getting rid of any match3s on the deal
			for (i=0;i<numRows;i++)
			{
				for(i2=0;i2<numColumns;i2++)
				{
					if ((i>0)&&(i2>0))
					{
						while((rowArray[i-1][i2].currentFrame==rowArray[i][i2].currentFrame)||(rowArray[i][i2-1].currentFrame==rowArray[i][i2].currentFrame))
						{
							rowArray[i][i2].changeTile();
						}
					}
					if ((i>0)&&(i2==0))
					{
						while(rowArray[i-1][i2].currentFrame==rowArray[i][i2].currentFrame)
						{
							rowArray[i][i2].changeTile();
						}
					}
					if((i==0)&&(i2>0))
					{
						while(rowArray[i][i2-1].currentFrame==rowArray[i][i2].currentFrame)
						{
							rowArray[i][i2].changeTile();
						}
					}
				}
			}
		}
		function btnMDown(e:MouseEvent):void
		{
			e.target.gotoAndStop("down");
		}
		function btnMOver(e:MouseEvent):void
		{
			e.target.gotoAndStop("over");
		}
		function btnMOut(e:MouseEvent):void
		{
			e.target.gotoAndStop("idle");
		}
		function restartBtnMUp(e:MouseEvent):void
		{
			e.target.gotoAndPlay("down");
			if (gameOverState)
			{
				reStart();
			}
			else
			{
				restartConfirm.visible=true;
				addChild(restartConfirm);
			}
		}
		function restartYesBtnUp (e:MouseEvent):void
		{
			reStart();
			restartConfirm.visible=false;
		}
		function restartNoBtnUp (e:MouseEvent):void
		{
			restartConfirm.visible=false;
		}
		function hintBtnUp(e:MouseEvent):void
		{
			if (hintArray.length!=0)
			{
				hintArray[0].glowBox.play();
				hintArray[1].glowBox.play();
			}
		}
		function submitBtnMUp(e:MouseEvent):void
		{
			//trace(gameOver.enterNameMC.inputName.text);
			var username:String;
			if (gameOver.enterNameMC.inputName.text!="")
			{
				username=gameOver.enterNameMC.inputName.text;
			}
			else
			{
				username="Player"
			}
			postScore(username, scoreField.text);
			gameOver.enterNameMC.visible=false;
			addChild(highScoreList);
			highScoreList.visible=true;
		}
		function topDogsBtnUp(e:MouseEvent):void
		{
			addChild(highScoreList);
			highScoreList.visible=true;
			getHighScores();
		}
		function highScoreCloseBtnClick(e:MouseEvent):void
		{
			highScoreList.visible=false;
		}
		function fullscreenBtnClick (e:MouseEvent):void
		{
			if (stage.displayState==StageDisplayState.FULL_SCREEN)
			{
				stage.displayState=StageDisplayState.NORMAL;
			}
			else
			{
				stage.displayState=StageDisplayState.FULL_SCREEN;
			}
		}
		function reStart():void
		{
			//check local highscore
			if(int(scoreField.text)>highScore)
			{
				highScore=highScoreSO.data.highScore=int(scoreField.text);
				highScoreField.text=""+highScore;
			}
			for (i=0;i<numRows;i++)
			{
				for(i2=0;i2<numColumns;i2++)
				{
					rowArray[i][i2].tileLevel=initTileLevel;
					rowArray[i][i2].changeTile();
				}
			}
			dePair();
			score=0;
			levelMark=levelMarker;
			currentLevel=0;
			numMatch5s=0;
			numMatch4s=0;
			match4field.text=""+numMatch4s;
			match5field.text=""+numMatch5s;
			scoreField.text=""+score;
			levelField.text=""+currentLevel;
			gameOverState=false;
			gameOver.gotoAndStop(0);
			highScoreList.visible=false;
		}
		function enterFrameEvent(e:Event):void
		{
			if (!isFading)
			{
				checkLevel();
				checkScores();
				prepHint();
			}
			
		}
		function refreshTiles():void
		{
			for (i=0;i<numRows;i++)
			{
				for(i2=0;i2<numColumns;i2++)
				{
					this["columnArray"+i][i2].y=(i*50)+yOffset;
					this["columnArray"+i][i2].x=(i2*50)+xOffset;
					this["columnArray"+i][i2].parent.addChild(this["columnArray"+i][i2]);
				}
			}
			addChild(gameOver);
		}
		function matcherMDown(e:MouseEvent):void
		{
			e.target.parent.addChild(e.target);
			e.target.startDrag();
		}
		function matcherMUp(e:MouseEvent):void
		{
			var swapMatch1:Object;
			var swapMatch2:Object;
			var swapMatch1_index1:int;
			var swapMatch1_index2:int;
			var swapMatch2_index1:int;
			var swapMatch2_index2:int;
			
			e.target.stopDrag();
			//check if the pieces are touching
			if (e.target.dropTarget!=null)
			{
				for (i=0;i<numRows;i++)
				{
					//prep the dragged tile for swapping
					if(this["columnArray"+i].indexOf(e.target)!=-1)
					{
						swapMatch1=rowArray[i][this["columnArray"+i].indexOf(e.target)];
						swapMatch1_index1=i;
						swapMatch1_index2=this["columnArray"+i].indexOf(e.target);
					}
					//prep the touching tile for swapping
					if(this["columnArray"+i].indexOf(e.target.dropTarget.parent)!=-1)
					{
						swapMatch2=rowArray[i][this["columnArray"+i].indexOf(e.target.dropTarget.parent)];
						swapMatch2_index1=i;
						swapMatch2_index2=this["columnArray"+i].indexOf(e.target.dropTarget.parent);
					}
				}
				//check if the swap is legal. The equation for checking if the touching tile is directly next (up, down, left, right) to the dragged tile is (x1-y1)squared+(x2-y2)squared=1
				var proximityTest:int = ((swapMatch1_index1-swapMatch2_index1)*(swapMatch1_index1-swapMatch2_index1))+((swapMatch1_index2-swapMatch2_index2)*(swapMatch1_index2-swapMatch2_index2));
				if (proximityTest==1)
				{
					swapOut(swapMatch1, swapMatch1_index1, swapMatch1_index2, swapMatch2, swapMatch2_index1, swapMatch2_index2);
				}
			}
			
			//just for testing, comment out the checks above and below too when using
			//swapOut(swapMatch1, swapMatch1_index1, swapMatch1_index2, swapMatch2, swapMatch2_index1, swapMatch2_index2);
			
			refreshTiles();
		}
		function swapOut(swapMatch1:Object, swapMatch1_index1:int, swapMatch1_index2:int, swapMatch2:Object, swapMatch2_index1:int, swapMatch2_index2:int):void
		{
			//check the legality part two. This time we're looking to see if the swap will make a score.
			//horizontal move
			if (swapMatch1_index1==swapMatch2_index1)
			{
				if (
					((swapMatch1_index1>1)&&(rowArray[swapMatch1_index1-2][swapMatch2_index2].currentFrame==swapMatch1.currentFrame)&&(rowArray[swapMatch1_index1-1][swapMatch2_index2].currentFrame==swapMatch1.currentFrame))||
					((swapMatch2_index1>1)&&(rowArray[swapMatch2_index1-2][swapMatch1_index2].currentFrame==swapMatch2.currentFrame)&&(rowArray[swapMatch2_index1-1][swapMatch1_index2].currentFrame==swapMatch2.currentFrame))||
					((swapMatch1_index1>0)&&(swapMatch1_index1<numRows-1)&&(rowArray[swapMatch1_index1-1][swapMatch2_index2].currentFrame==swapMatch1.currentFrame)&&(rowArray[swapMatch1_index1+1][swapMatch2_index2].currentFrame==swapMatch1.currentFrame))||
					((swapMatch2_index1>0)&&(swapMatch2_index1<numRows-1)&&(rowArray[swapMatch2_index1-1][swapMatch1_index2].currentFrame==swapMatch2.currentFrame)&&(rowArray[swapMatch2_index1+1][swapMatch1_index2].currentFrame==swapMatch2.currentFrame))||
					((swapMatch1_index1<numRows-2)&&(rowArray[swapMatch1_index1+2][swapMatch2_index2].currentFrame==swapMatch1.currentFrame)&&(rowArray[swapMatch1_index1+1][swapMatch2_index2].currentFrame==swapMatch1.currentFrame))||
					((swapMatch2_index1<numRows-2)&&(rowArray[swapMatch2_index1+2][swapMatch1_index2].currentFrame==swapMatch2.currentFrame)&&(rowArray[swapMatch2_index1+1][swapMatch1_index2].currentFrame==swapMatch2.currentFrame))||
					((swapMatch2_index2>1)&&(swapMatch1!=rowArray[swapMatch1_index1][swapMatch2_index2-1])&&(rowArray[swapMatch1_index1][swapMatch2_index2-2].currentFrame==swapMatch1.currentFrame)&&(rowArray[swapMatch1_index1][swapMatch2_index2-1].currentFrame==swapMatch1.currentFrame))||
					((swapMatch1_index2>1)&&(swapMatch2!=rowArray[swapMatch2_index1][swapMatch1_index2-1])&&(rowArray[swapMatch2_index1][swapMatch1_index2-2].currentFrame==swapMatch2.currentFrame)&&(rowArray[swapMatch2_index1][swapMatch1_index2-1].currentFrame==swapMatch2.currentFrame))||
					((swapMatch2_index2<numColumns-2)&&(swapMatch1!=rowArray[swapMatch1_index1][swapMatch2_index2+1])&&(rowArray[swapMatch1_index1][swapMatch2_index2+2].currentFrame==swapMatch1.currentFrame)&&(rowArray[swapMatch1_index1][swapMatch2_index2+1].currentFrame==swapMatch1.currentFrame))||
					((swapMatch1_index2<numColumns-2)&&(swapMatch2!=rowArray[swapMatch2_index1][swapMatch1_index2+1])&&(rowArray[swapMatch2_index1][swapMatch1_index2+2].currentFrame==swapMatch2.currentFrame)&&(rowArray[swapMatch2_index1][swapMatch1_index2+1].currentFrame==swapMatch2.currentFrame))
					)
				{
					rowArray[swapMatch2_index1][swapMatch2_index2]=swapMatch1;
					rowArray[swapMatch1_index1][swapMatch1_index2]=swapMatch2;
				}
			}
			//vertical move
			if (swapMatch1_index2==swapMatch2_index2)
			{
				if(
				   (isFading)||
				   (rowClearing)||
				   ((swapMatch1_index2>1)&&(rowArray[swapMatch2_index1][swapMatch1_index2-2].currentFrame==swapMatch1.currentFrame)&&(rowArray[swapMatch2_index1][swapMatch1_index2-1].currentFrame==swapMatch1.currentFrame))||
				   ((swapMatch2_index2>1)&&(rowArray[swapMatch1_index1][swapMatch2_index2-2].currentFrame==swapMatch2.currentFrame)&&(rowArray[swapMatch1_index1][swapMatch2_index2-1].currentFrame==swapMatch2.currentFrame))||
				   ((swapMatch1_index2<numColumns-2)&&(rowArray[swapMatch2_index1][swapMatch1_index2+2].currentFrame==swapMatch1.currentFrame)&&(rowArray[swapMatch2_index1][swapMatch1_index2+1].currentFrame==swapMatch1.currentFrame))||
				   ((swapMatch2_index2<numColumns-2)&&(rowArray[swapMatch1_index1][swapMatch2_index2+2].currentFrame==swapMatch2.currentFrame)&&(rowArray[swapMatch1_index1][swapMatch2_index2+1].currentFrame==swapMatch2.currentFrame))||
				   ((swapMatch1_index2>0)&&(swapMatch1_index2<numColumns-1)&&(rowArray[swapMatch2_index1][swapMatch1_index2-1].currentFrame==swapMatch1.currentFrame)&&(rowArray[swapMatch2_index1][swapMatch1_index2+1].currentFrame==swapMatch1.currentFrame))||
				   ((swapMatch2_index2>0)&&(swapMatch2_index2<numColumns-1)&&(rowArray[swapMatch1_index1][swapMatch2_index2-1].currentFrame==swapMatch2.currentFrame)&&(rowArray[swapMatch1_index1][swapMatch2_index2+1].currentFrame==swapMatch2.currentFrame))||
				   ((swapMatch2_index1>1)&&(rowArray[swapMatch2_index1-1][swapMatch2_index2]!=swapMatch1)&&(rowArray[swapMatch2_index1-2][swapMatch2_index2].currentFrame==swapMatch1.currentFrame)&&(rowArray[swapMatch2_index1-1][swapMatch2_index2].currentFrame==swapMatch1.currentFrame))||
				   ((swapMatch1_index1>1)&&(rowArray[swapMatch1_index1-1][swapMatch1_index2]!=swapMatch2)&&(rowArray[swapMatch1_index1-2][swapMatch1_index2].currentFrame==swapMatch2.currentFrame)&&(rowArray[swapMatch1_index1-1][swapMatch1_index2].currentFrame==swapMatch2.currentFrame))||
				   ((swapMatch2_index1<numRows-2)&&(rowArray[swapMatch2_index1+1][swapMatch2_index2]!=swapMatch1)&&(rowArray[swapMatch2_index1+2][swapMatch2_index2].currentFrame==swapMatch1.currentFrame)&&(rowArray[swapMatch2_index1+1][swapMatch2_index2].currentFrame==swapMatch1.currentFrame))||
				   ((swapMatch1_index1<numRows-2)&&(rowArray[swapMatch1_index1+1][swapMatch1_index2]!=swapMatch2)&&(rowArray[swapMatch1_index1+2][swapMatch1_index2].currentFrame==swapMatch2.currentFrame)&&(rowArray[swapMatch1_index1+1][swapMatch1_index2].currentFrame==swapMatch2.currentFrame))
				   )
				{   
					rowArray[swapMatch2_index1][swapMatch2_index2]=swapMatch1;
					rowArray[swapMatch1_index1][swapMatch1_index2]=swapMatch2;
				}
			}
			
			//Again, just use this for TESTING
			/*rowArray[swapMatch2_index1][swapMatch2_index2]=swapMatch1;
			rowArray[swapMatch1_index1][swapMatch1_index2]=swapMatch2;*/
			
		}
		function checkLevel():void
		{
			if ((score-levelMark)>0)
			{
				for (i=0;i<numRows;i++)
				{
					for (i2=0;i2<numColumns;i2++)
					{
						rowArray[i][i2].tileLevel++;
					}
				}
				currentLevel++;
				levelMark=(currentLevel+1)*levelMarker;
				levelField.text=""+currentLevel;
			}
		}
		function prepHint():void
		{
			hintArray=[];
			
			//check the verticals for match3s part one, to the right
			for (i=0;i<(numColumns-1);i++)
			{
				for (i2=0;i2<(numRows-2);i2++)
				{
					if ((rowArray[i2][i+1].currentFrame==rowArray[i2+1][i].currentFrame)&&(rowArray[i2+1][i].currentFrame==rowArray[i2+2][i].currentFrame))
					{
						hintArray.push(rowArray[i2][i+1]);
						hintArray.push(rowArray[i2][i]);
						return;
					}
				}
				for (i2=1;i2<(numRows-1);i2++)
				{
					if ((rowArray[i2][i+1].currentFrame==rowArray[i2+1][i].currentFrame)&&(rowArray[i2+1][i].currentFrame==rowArray[i2-1][i].currentFrame))
					{
						hintArray.push(rowArray[i2][i+1]);
						hintArray.push(rowArray[i2][i]);
						return;
					}
				}
				for (i2=2;i2<(numRows);i2++)
				{
					if ((rowArray[i2][i+1].currentFrame==rowArray[i2-1][i].currentFrame)&&(rowArray[i2-1][i].currentFrame==rowArray[i2-2][i].currentFrame))
					{
						hintArray.push(rowArray[i2][i+1]);
						hintArray.push(rowArray[i2][i]);
						return;
					}
				}
			}
			//check the horizontals for match3s part one, the row above
			for (i=1;i<(numRows);i++)
			{
				for(i2=0;i2<(numColumns-2);i2++)
				{
					if ((rowArray[i-1][i2].currentFrame==rowArray[i][i2+1].currentFrame)&&(rowArray[i][i2+1].currentFrame==rowArray[i][i2+2].currentFrame))
					{
						hintArray.push(rowArray[i-1][i2]);
						hintArray.push(rowArray[i][i2]);
						return;
					}
				}
				for(i2=1;i2<(numColumns-1);i2++)
				{
					if ((rowArray[i-1][i2].currentFrame==rowArray[i][i2+1].currentFrame)&&(rowArray[i][i2-1].currentFrame==rowArray[i][i2+1].currentFrame))
					{
						hintArray.push(rowArray[i-1][i2]);
						hintArray.push(rowArray[i][i2]);
						return;
					}
				}
				for(i2=2;i2<(numColumns);i2++)
				{
					if ((rowArray[i-1][i2].currentFrame==rowArray[i][i2-1].currentFrame)&&(rowArray[i][i2-1].currentFrame==rowArray[i][i2-2].currentFrame))
					{
						hintArray.push(rowArray[i-1][i2]);
						hintArray.push(rowArray[i][i2]);
						return;
					}
				}
			}
			//check the verticals for match3s part two, to the left
			for (i=1;i<(numColumns);i++)
			{
				for (i2=0;i2<(numRows-2);i2++)
				{
					if ((rowArray[i2][i-1].currentFrame==rowArray[i2+1][i].currentFrame)&&(rowArray[i2+1][i].currentFrame==rowArray[i2+2][i].currentFrame))
					{
						hintArray.push(rowArray[i2][i-1]);
						hintArray.push(rowArray[i2][i]);
						return;
					}
				}
				for (i2=1;i2<(numRows-1);i2++)
				{
					if ((rowArray[i2][i-1].currentFrame==rowArray[i2+1][i].currentFrame)&&(rowArray[i2+1][i].currentFrame==rowArray[i2-1][i].currentFrame))
					{
						hintArray.push(rowArray[i2][i-1]);
						hintArray.push(rowArray[i2][i]);
						return;
					}
				}
				for (i2=2;i2<(numRows);i2++)
				{
					if ((rowArray[i2][i-1].currentFrame==rowArray[i2-1][i].currentFrame)&&(rowArray[i2-1][i].currentFrame==rowArray[i2-2][i].currentFrame))
					{
						hintArray.push(rowArray[i2][i-1]);
						hintArray.push(rowArray[i2][i]);
						return;
					}
				}
			}
			//check the horizontals for match3s part two, the row below
			for (i=0;i<(numRows-1);i++)
			{
				for(i2=0;i2<(numColumns-2);i2++)
				{
					if ((rowArray[i+1][i2].currentFrame==rowArray[i][i2+1].currentFrame)&&(rowArray[i][i2+1].currentFrame==rowArray[i][i2+2].currentFrame))
					{
						hintArray.push(rowArray[i+1][i2]);
						hintArray.push(rowArray[i][i2]);
						return;
					}
				}
				for(i2=1;i2<(numColumns-1);i2++)
				{
					if ((rowArray[i+1][i2].currentFrame==rowArray[i][i2+1].currentFrame)&&(rowArray[i][i2-1].currentFrame==rowArray[i][i2+1].currentFrame))
					{
						hintArray.push(rowArray[i+1][i2]);
						hintArray.push(rowArray[i][i2]);
						return;
					}
				}
				for(i2=2;i2<(numColumns);i2++)
				{
					if ((rowArray[i+1][i2].currentFrame==rowArray[i][i2-1].currentFrame)&&(rowArray[i][i2-1].currentFrame==rowArray[i][i2-2].currentFrame))
					{
						hintArray.push(rowArray[i+1][i2]);
						hintArray.push(rowArray[i][i2]);
						return;
					}
				}
			}
			//check the verticals for match3s part three, the hanging top piece
			for (i=0;i<numColumns;i++)
			{
				for (i2=1;i2<(numRows-2);i2++)
				{
					if((rowArray[i2-1][i].currentFrame==rowArray[i2+1][i].currentFrame)&&(rowArray[i2+1][i].currentFrame==rowArray[i2+2][i].currentFrame))
					{
						hintArray.push(rowArray[i2-1][i]);
						hintArray.push(rowArray[i2][i]);
						return;
					}
				}
			}
			//check the horizontals for match3s part three, the hanging right one
			for (i=0;i<(numRows);i++)
			{
				for(i2=0;i2<(numColumns-4);i2++)
				{
					if ((rowArray[i][i2].currentFrame==rowArray[i][i2+1].currentFrame)&&(rowArray[i][i2+1].currentFrame==rowArray[i][i2+3].currentFrame))
					{
						hintArray.push(rowArray[i][i2+3]);
						hintArray.push(rowArray[i][i2+2]);			
						return;
					}
				}
			}
			//check the verticals for match3s part four, the hanging bottom piece
			for (i=0;i<numColumns;i++)
			{
				for (i2=0;i2<(numRows-3);i2++)
				{
					if((rowArray[i2][i].currentFrame==rowArray[i2+1][i].currentFrame)&&(rowArray[i2+1][i].currentFrame==rowArray[i2+3][i].currentFrame))
					{
						hintArray.push(rowArray[i2+3][i]);
						hintArray.push(rowArray[i2+2][i]);
						return;
					}
				}
			}
			//check the horizontals for match3s part four, the hanging left one
			for (i=0;i<(numRows);i++)
			{
				for(i2=1;i2<(numColumns-2);i2++)
				{
					if ((rowArray[i][i2-1].currentFrame==rowArray[i][i2+1].currentFrame)&&(rowArray[i][i2+1].currentFrame==rowArray[i][i2+2].currentFrame))
					{
						hintArray.push(rowArray[i][i2-1]);
						hintArray.push(rowArray[i][i2]);			
						return;
					}
				}
			}
			if ((hintArray.length==0)&&(!gameOverState)&&(!isFading)&&(!rowClearing))
			{
				endGame();
				getHighScores();
			}
		}
		function checkScores():void
		{
			//check for ┌ shaped match5s
			for (i=0;i<numRows-2;i++)
			{
				for(i2=0;i2<numColumns-2;i2++)
				{
					if((rowArray[i][i2].currentFrame==rowArray[i+1][i2].currentFrame)&&(rowArray[i][i2].currentFrame==rowArray[i+2][i2].currentFrame)&&(rowArray[i][i2].currentFrame==rowArray[i][i2+1].currentFrame)&&(rowArray[i][i2].currentFrame==rowArray[i][i2+2].currentFrame))
					{
						if (dog.currentLabel=="idle")
						{
							dog.gotoAndPlay(rowArray[i][i2].currentLabel);
						}
						numMatch5s++;
						match5field.text=""+numMatch5s;
						fadeOut(rowArray[i][i2]);
						fadeOut(rowArray[i][i2+1]);
						fadeOut(rowArray[i][i2+2]);
						fadeOut(rowArray[i+1][i2]);
						fadeOut(rowArray[i+2][i2]);
						return;
					}
				}
			}
			
			//check for L shaped match 5s
			for (i=2;i<numRows;i++)
			{
				for (i2=0;i2<numColumns-2;i2++)
				{
					if ((rowArray[i][i2].currentFrame==rowArray[i-1][i2].currentFrame)&&(rowArray[i][i2].currentFrame==rowArray[i-2][i2].currentFrame)&&(rowArray[i][i2].currentFrame==rowArray[i][i2+1].currentFrame)&&(rowArray[i][i2].currentFrame==rowArray[i][i2+2].currentFrame))
					{
						if (dog.currentLabel=="idle")
						{
							dog.gotoAndPlay(rowArray[i][i2].currentLabel);
						}
						numMatch5s++;
						match5field.text=""+numMatch5s;
						fadeOut(rowArray[i][i2]);
						fadeOut(rowArray[i][i2+1]);
						fadeOut(rowArray[i][i2+2]);
						fadeOut(rowArray[i-1][i2]);
						fadeOut(rowArray[i-2][i2]);
						return;
					}
				}
			}
			
			//check for ┘ shaped match 5s
			for (i=2;i<numRows;i++)
			{
				for (i2=2;i2<numColumns;i2++)
				{
					if ((rowArray[i][i2].currentFrame==rowArray[i-1][i2].currentFrame)&&(rowArray[i][i2].currentFrame==rowArray[i-2][i2].currentFrame)&&(rowArray[i][i2].currentFrame==rowArray[i][i2-1].currentFrame)&&(rowArray[i][i2].currentFrame==rowArray[i][i2-2].currentFrame))
					{
						if (dog.currentLabel=="idle")
						{
							dog.gotoAndPlay(rowArray[i][i2].currentLabel);
						}
						numMatch5s++;
						match5field.text=""+numMatch5s;
						fadeOut(rowArray[i][i2]);
						fadeOut(rowArray[i][i2-1]);
						fadeOut(rowArray[i][i2-2]);
						fadeOut(rowArray[i-1][i2]);
						fadeOut(rowArray[i-2][i2]);
						return;
					}
				}
			}
			
			//check for ┐ shaped match 5s
			for (i=0;i<numRows-2;i++)
			{
				for (i2=2;i2<numColumns;i2++)
				{
					if ((rowArray[i][i2].currentFrame==rowArray[i+1][i2].currentFrame)&&(rowArray[i][i2].currentFrame==rowArray[i+2][i2].currentFrame)&&(rowArray[i][i2].currentFrame==rowArray[i][i2-1].currentFrame)&&(rowArray[i][i2].currentFrame==rowArray[i][i2-2].currentFrame))
					{
						if (dog.currentLabel=="idle")
						{
							dog.gotoAndPlay(rowArray[i][i2].currentLabel);
						}
						numMatch5s++;
						match5field.text=""+numMatch5s;
						fadeOut(rowArray[i][i2]);
						fadeOut(rowArray[i][i2-1]);
						fadeOut(rowArray[i][i2-2]);
						fadeOut(rowArray[i+1][i2]);
						fadeOut(rowArray[i+2][i2]);
						return;
					}
				}
			}
			
			//check for T shaped match 5s
			for (i=0;i<numRows-2;i++)
			{
				for (i2=1;i2<numColumns-1;i2++)
				{
					if ((rowArray[i][i2].currentFrame==rowArray[i+1][i2].currentFrame)&&(rowArray[i][i2].currentFrame==rowArray[i+2][i2].currentFrame)&&(rowArray[i][i2].currentFrame==rowArray[i][i2-1].currentFrame)&&(rowArray[i][i2].currentFrame==rowArray[i][i2+1].currentFrame))
					{
						if (dog.currentLabel=="idle")
						{
							dog.gotoAndPlay(rowArray[i][i2].currentLabel);
						}
						numMatch5s++;
						match5field.text=""+numMatch5s;
						fadeOut(rowArray[i][i2]);
						fadeOut(rowArray[i][i2-1]);
						fadeOut(rowArray[i][i2+1]);
						fadeOut(rowArray[i+1][i2]);
						fadeOut(rowArray[i+2][i2]);
						return;
					}
				}
			}
			
			//check for ┴ shaped match 5s
			for (i=2;i<numRows;i++)
			{
				for (i2=1;i2<numColumns-1;i2++)
				{
					if ((rowArray[i][i2].currentFrame==rowArray[i-1][i2].currentFrame)&&(rowArray[i][i2].currentFrame==rowArray[i-2][i2].currentFrame)&&(rowArray[i][i2].currentFrame==rowArray[i][i2-1].currentFrame)&&(rowArray[i][i2].currentFrame==rowArray[i][i2+1].currentFrame))
					{
						if (dog.currentLabel=="idle")
						{
							dog.gotoAndPlay(rowArray[i][i2].currentLabel);
						}
						numMatch5s++;
						match5field.text=""+numMatch5s;
						fadeOut(rowArray[i][i2]);
						fadeOut(rowArray[i][i2-1]);
						fadeOut(rowArray[i][i2+1]);
						fadeOut(rowArray[i-1][i2]);
						fadeOut(rowArray[i-2][i2]);
						return;
					}
				}
			}
			
			//check for ├ shaped match 5s
			for (i=1;i<numRows-1;i++)
			{
				for (i2=0;i2<numColumns-2;i2++)
				{
					if ((rowArray[i][i2].currentFrame==rowArray[i-1][i2].currentFrame)&&(rowArray[i][i2].currentFrame==rowArray[i+1][i2].currentFrame)&&(rowArray[i][i2].currentFrame==rowArray[i][i2+1].currentFrame)&&(rowArray[i][i2].currentFrame==rowArray[i][i2+2].currentFrame))
					{
						if (dog.currentLabel=="idle")
						{
							dog.gotoAndPlay(rowArray[i][i2].currentLabel);
						}
						numMatch5s++;
						match5field.text=""+numMatch5s;
						fadeOut(rowArray[i][i2]);
						fadeOut(rowArray[i][i2+1]);
						fadeOut(rowArray[i][i2+2]);
						fadeOut(rowArray[i-1][i2]);
						fadeOut(rowArray[i+1][i2]);
						return;
					}
				}
			}
			
			//check for ┤ shaped match 5s
			for (i=1;i<numRows-1;i++)
			{
				for (i2=2;i2<numColumns;i2++)
				{
					if ((rowArray[i][i2].currentFrame==rowArray[i-1][i2].currentFrame)&&(rowArray[i][i2].currentFrame==rowArray[i+1][i2].currentFrame)&&(rowArray[i][i2].currentFrame==rowArray[i][i2-1].currentFrame)&&(rowArray[i][i2].currentFrame==rowArray[i][i2-2].currentFrame))
					{
						if (dog.currentLabel=="idle")
						{
							dog.gotoAndPlay(rowArray[i][i2].currentLabel);
						}
						numMatch5s++;
						match5field.text=""+numMatch5s;
						fadeOut(rowArray[i][i2]);
						fadeOut(rowArray[i][i2-1]);
						fadeOut(rowArray[i][i2-2]);
						fadeOut(rowArray[i-1][i2]);
						fadeOut(rowArray[i+1][i2]);
						return;
					}
				}
			}
			
			//check the horizontals for straight match5s
			for (i=0;i<numRows;i++)
			{
				for(i2=0;i2<(numColumns-4);i2++)
				{
					if ((rowArray[i][i2].currentFrame==rowArray[i][i2+1].currentFrame)&&(rowArray[i][i2].currentFrame==rowArray[i][i2+2].currentFrame)&&(rowArray[i][i2].currentFrame==rowArray[i][i2+3].currentFrame)&&(rowArray[i][i2].currentFrame==rowArray[i][i2+4].currentFrame))
					{
						//trace(""+rowArray[i][i2].currentLabel+"x5");
						if (dog.currentLabel=="idle")
						{
							dog.gotoAndPlay(rowArray[i][i2].currentLabel);
						}
						numMatch5s++;
						match5field.text=""+numMatch5s;
						fadeOut(rowArray[i][i2]);
						fadeOut(rowArray[i][i2+1]);
						fadeOut(rowArray[i][i2+2]);
						fadeOut(rowArray[i][i2+3]);
						fadeOut(rowArray[i][i2+4]);
						return;
					}
				}
			}
			//check the verticals for straight match5s
			for (i=0;i<(numColumns);i++)
			{
				for (i2=0;i2<(numRows-4);i2++)
				{
					if ((rowArray[i2][i].currentFrame==rowArray[i2+1][i].currentFrame)&&(rowArray[i2][i].currentFrame==rowArray[i2+2][i].currentFrame)&&(rowArray[i2][i].currentFrame==rowArray[i2+3][i].currentFrame)&&(rowArray[i2][i].currentFrame==rowArray[i2+4][i].currentFrame))
					{
						//trace(""+rowArray[i2][i].currentLabel+"x5");
						if (dog.currentLabel=="idle")
						{
							dog.gotoAndPlay(rowArray[i2][i].currentLabel);
						}
						numMatch5s++;
						match5field.text=""+numMatch5s;
						fadeOut(rowArray[i2][i]);
						fadeOut(rowArray[i2+1][i]);
						fadeOut(rowArray[i2+2][i]);
						fadeOut(rowArray[i2+3][i]);
						fadeOut(rowArray[i2+4][i]);
						return;
					}
				}
			}
			//check the horizontals for match4s
			for (i=0;i<numRows;i++)
			{
				for(i2=0;i2<(numColumns-3);i2++)
				{
					if ((rowArray[i][i2].currentFrame==rowArray[i][i2+1].currentFrame)&&(rowArray[i][i2].currentFrame==rowArray[i][i2+2].currentFrame)&&(rowArray[i][i2].currentFrame==rowArray[i][i2+3].currentFrame))
					{
						//trace(""+rowArray[i][i2].currentLabel+"x4");
						if (dog.currentLabel=="idle")
						{
							dog.gotoAndPlay(rowArray[i][i2].currentLabel);
						}
						numMatch4s++;
						match4field.text=""+numMatch4s;
						fadeOut(rowArray[i][i2]);
						fadeOut(rowArray[i][i2+1]);
						fadeOut(rowArray[i][i2+2]);
						fadeOut(rowArray[i][i2+3]);
						return;
					}
				}
			}
			//check the verticals for match4s
			for (i=0;i<(numColumns);i++)
			{
				for (i2=0;i2<(numRows-3);i2++)
				{
					if ((rowArray[i2][i].currentFrame==rowArray[i2+1][i].currentFrame)&&(rowArray[i2][i].currentFrame==rowArray[i2+2][i].currentFrame)&&(rowArray[i2][i].currentFrame==rowArray[i2+3][i].currentFrame))
					{
						//trace(""+rowArray[i2][i].currentLabel+"x4");
						if (dog.currentLabel=="idle")
						{
							dog.gotoAndPlay(rowArray[i2][i].currentLabel);
						}
						numMatch4s++;
						match4field.text=""+numMatch4s
						fadeOut(rowArray[i2][i]);
						fadeOut(rowArray[i2+1][i]);
						fadeOut(rowArray[i2+2][i]);
						fadeOut(rowArray[i2+3][i]);
						return;
					}
				}
			}
			//check the horizontals for match3s
			for (i=0;i<numRows;i++)
			{
				for(i2=0;i2<(numColumns-2);i2++)
				{
					if ((rowArray[i][i2].currentFrame==rowArray[i][i2+1].currentFrame)&&(rowArray[i][i2+1].currentFrame==rowArray[i][i2+2].currentFrame))
					{
						fadeOut(rowArray[i][i2]);
						fadeOut(rowArray[i][i2+1]);
						fadeOut(rowArray[i][i2+2]);
						return;
					}
				}
			}
			//check the verticals for match3s
			for (i=0;i<(numColumns);i++)
			{
				for (i2=0;i2<(numRows-2);i2++)
				{
					if ((rowArray[i2][i].currentFrame==rowArray[i2+1][i].currentFrame)&&(rowArray[i2+1][i].currentFrame==rowArray[i2+2][i].currentFrame))
					{
						fadeOut(rowArray[i2][i]);
						fadeOut(rowArray[i2+1][i]);
						fadeOut(rowArray[i2+2][i]);
						return;
					}
				}
			}
		}
		function fadeOut(fader:Object):void
		{
			isFading=true;
			var fadeOutTimer:Timer=new Timer(25, 10);
			fadeOutTimer.addEventListener(TimerEvent.TIMER, fadeOutTimerAction);
			fadeOutTimer.addEventListener(TimerEvent.TIMER_COMPLETE, fadeOutTimerOverAction);
			fadeOutTimer.start();
			function fadeOutTimerAction(e:TimerEvent):void
			{
				fader.scaleX*=1.1;
				fader.scaleY*=1.1;
				fader.alpha*=.9;
				fader.parent.addChild(fader);
			}
			function fadeOutTimerOverAction(e:TimerEvent):void
			{
				fader.scaleX=fader.scaleY=fader.alpha=1;
				fadeOutTimer.removeEventListener(TimerEvent.TIMER, fadeOutTimerAction);
				fadeOutTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, fadeOutTimerOverAction);
				scoreOut(fader);
				isFading=false;
			}
		}
		function scoreOut(scorer:Object):void
		{
			rowClearing=true;
			scorer.scaleX=scorer.scaleY=scorer.alpha=1;
			var rowDepth:int;
			var columnMarker:int;
			//find our stating values to fill in the row
			for (i=0;i<numRows;i++)
			{
				for(i2=0;i2<numColumns;i2++)
				{
					if(this["columnArray"+i].indexOf(scorer)!=-1)
					{
						rowDepth=i;
						columnMarker=this["columnArray"+i].indexOf(scorer);
					}
				}
			}
			//move the rows down
			if (rowDepth>0)
			{
				for (i=(rowDepth+1);i>1;i--)
				{
					swapOut(rowArray[i-1][columnMarker], (i-1), columnMarker, rowArray[i-2][columnMarker], (i-2), columnMarker);
				}
			}
			//reset the topline tile
			rowArray[0][columnMarker].changeTile();
			refreshTiles();
			//add points to the scoreboard
			score+=1;
			scoreField.text=""+((10*score)+(40*numMatch4s)+(50*numMatch5s));
			rowClearing=false;
		}
		function endGame():void
		{
			//trace("game over dude");
			gameOverState=true;
			addChild(gameOver);
			gameOver.play();
			//local highscore now
			if(int(scoreField.text)>highScore)
			{
				highScore=highScoreSO.data.highScore=int(scoreField.text);
				highScoreField.text=""+highScore;
			}
			/*if (int(scoreField.text)>int(highScoreXML.player[9].score.@score))
			{
				if (stage.displayState==StageDisplayState.FULL_SCREEN)
				{
					stage.displayState=StageDisplayState.NORMAL;
				}
				gameOver.enterNameMC.visible=true;
			}
			else
			{
				addChild(highScoreList);
				highScoreList.visible=true;
			}*/
		}
		//leaderboard stuff. That shitty hosting service is broke, so time to rewrite
		function postScore(username:String, finalScore:String):void 
		{
			/*var url:String = "https://www.scoreoid.com/api/createScore";
			var request:URLRequest = new URLRequest(url);
			var requestVars:URLVariables = new URLVariables();
			request.data = requestVars;
			requestVars.api_key = "986ca2f65f491a4fece9670a91ca23cd3d2a0536";
			requestVars.game_id = "1f1698c481";
			requestVars.response ="XML"
				requestVars.username =username;
				requestVars.score =finalScore;
				
				request.method = URLRequestMethod.POST;
			
			var urlLoader:URLLoader = new URLLoader();
				urlLoader = new URLLoader();
				urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
				urlLoader.addEventListener(Event.COMPLETE, loaderCompleteHandler);
		
				urlLoader.load(request);*/
		}
		function getHighScores():void
		{
			/*var url:String = "https://www.scoreoid.com/api/getScores";
			var request:URLRequest = new URLRequest(url);
			var requestVars:URLVariables = new URLVariables();
			request.data = requestVars;
			requestVars.api_key = "986ca2f65f491a4fece9670a91ca23cd3d2a0536";
			requestVars.game_id = "1f1698c481";
			requestVars.response ="XML"
				requestVars.order_by = "score";
				requestVars.order = "desc";
				requestVars.limit = "10";
				
				request.method = URLRequestMethod.POST;
			
			var urlLoader:URLLoader = new URLLoader();
				urlLoader = new URLLoader();
				urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
				urlLoader.addEventListener(Event.COMPLETE, highScoreCompleteHandler);
		
				urlLoader.load(request);*/
		}
		function highScoreCompleteHandler(event:Event):void
		{
			highScoreList.highScoreListText.text="";
			highScoreXML=XML(event.target.data);
			//trace(highScoreXML);
			for (i=0;i<10;i++)
			{
				highScoreList.highScoreListText.text+=(highScoreXML.player[i].@username)+" ";
				highScoreList.highScoreListText.text+=(highScoreXML.player[i].score.@score)+"\n";
				//trace(highScoreXML.player[i].@username, highScoreXML.player[i].score.@score);
			}
			highScoreList.highScoreListText.parent.addChild(highScoreList.highScoreListText);
		}
		function loaderCompleteHandler(event:Event):void 
		{
			trace("responseVars: " + event.target.data);
			getHighScores();
		}
	}
}