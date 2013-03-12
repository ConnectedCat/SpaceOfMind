﻿package {	import flash.display.*;	import flash.events.*;//for event handling	import flash.net.Socket;//Sockets	import com.adobe.serialization.json.*;//as3corelib JSON support	//import fl.transitions.*;//for animation	//import fl.transitions.easing.*;//for animation	import flash.geom.*;//for ColorTransform	public class DisplayWindow extends Sprite	{		// Public Properties:		public var attention:uint;		public var meditation:uint;		public var poorSignal:uint;		// Private Properties:		private var thinkGearSocket:Socket;		private var circle:Sprite;//add sprite		public function DisplayWindow()		{			// constructor code			circle = new Sprite();			circle.graphics.beginFill(0x000000);			circle.graphics.drawCircle(200, 200, 200);			circle.graphics.endFill();			addChild(circle);			thinkGearSocket = new Socket();			thinkGearSocket.addEventListener(ProgressEvent.SOCKET_DATA, dataHandler);			thinkGearSocket.connect("127.0.0.1", 13854);			var configuration : Object = new Object();			configuration["enableRawOutput"] = false;			configuration["format"] = "Json";			thinkGearSocket.writeUTFBytes(JSON.encode(configuration));		}		// Protected Methods:;		private function dataHandler(e : ProgressEvent)		{			var packetString:String = thinkGearSocket.readUTFBytes(thinkGearSocket.bytesAvailable);			thinkGearSocket.flush();			var packets:Array = packetString.split(/\r/);			var data:Object;			for each (var packet:String in packets)			{				if (packet != "")				{					try					{						data = JSON.decode(packet);					}					catch (jError:JSONParseError)					{						//do error handling here					}					if (data["poorSignalLevel"] != null)					{						poorSignal = data["poorSignalLevel"];						//var yTween:Tween;						if (poorSignal == 0)						{							attention = data["eSense"]["attention"];							meditation = data["eSense"]["meditation"];							var red:uint = map(meditation,0,200,0,255);							var green:uint = map(attention,0,200,0,255);							var blue:uint = map(meditation,0,200,0,255);							var myColorTransform = new ColorTransform(0,0,0,1,red,green,blue,0);							circle.transform.colorTransform = myColorTransform;							//var newPos:int = 350 - (attention * 3.5);//calculate new position of ball							//yTween = new Tween(circle,"y",Elastic.easeOut,circle.y,newPos,0.95,true);//move ball						}						else						{							if (poorSignal == 200)							{								attention = 0;								meditation = 0;								//yTween = new Tween(circle,"y",Strong.easeOut,circle.y,350,0.75,true);//move ball back							}						}					}				}				data = null;				label1.text = "Attention: " + attention.toString() + "\nMeditation: " + meditation.toString() + "\nPoor Signal: " + poorSignal.toString();			}/*for each*/		}/*function dataHandler*/		private function map(v:Number, a:Number, b:Number, x:Number = 0, y:Number = 1):Number		{			return (v == a) ? x : (v - a) * (y - x) / (b - a) + x;		}	}}