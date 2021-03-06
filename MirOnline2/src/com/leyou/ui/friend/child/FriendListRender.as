package com.leyou.ui.friend.child {
	import com.ace.manager.LibManager;
	import com.ace.tools.ScaleBitmap;
	import com.ace.ui.auto.AutoSprite;
	import com.ace.ui.img.child.Image;
	import com.ace.ui.lable.Label;
	import com.leyou.data.friend.FriendInfo;
	import com.leyou.utils.PlayerUtil;

	public class FriendListRender extends AutoSprite {
		private var userHeadImg:Image;
		private var nameLbl:Label;
		private var levelLbl:Label;
		private var memberLbl:Label;
		private var selectScBtm:Image;
		private var timeLbl:Label;
		private var highLightSBM:ScaleBitmap;
		public var id:int;

		public function FriendListRender() {
			super(LibManager.getInstance().getXML("config/ui/friend/FriendDateBar.xml"));
			this.init();
			this.mouseEnabled=true;
		}

		private function init():void {
			this.userHeadImg=this.getUIbyID("userHeadImg") as Image;
			this.nameLbl=this.getUIbyID("nameLbl") as Label;
			this.levelLbl=this.getUIbyID("levelLbl") as Label;
			this.memberLbl=this.getUIbyID("memberLbl") as Label;
			this.selectScBtm=this.getUIbyID("selectScBtm") as Image;
			this.timeLbl=this.getUIbyID("timeLbl") as Label;
			this.highLightSBM=this.getUIbyID("highLightSBM") as ScaleBitmap;
			this.selectScBtm.visible=false;
			this.highLightSBM.visible=false;
		}

		public function updata(infor:FriendInfo):void {
			this.nameLbl.text=infor.name;
			this.levelLbl.text=infor.lv.toString();
			this.memberLbl.text=PlayerUtil.getPlayerMemberByid(infor.mumber);
			this.timeLbl.text=infor.outLineTime;
			this.userHeadImg.updateBmp(PlayerUtil.getOtherPlayerHeadImg(infor.race, infor.sex));
		}

		public function set hightLight(flag:Boolean):void {
			this.selectScBtm.visible=flag;
			this.highLightSBM.visible=flag;
		}

		public function get userNameLbl():Label {
			return nameLbl;
		}

		public function get memLbl():Label {
			return memberLbl;
		}

		public function get lvLbl():Label {
			return levelLbl;
		}

		public function get lasttimeLbl():Label {
			return this.timeLbl;
		}

	}
}
