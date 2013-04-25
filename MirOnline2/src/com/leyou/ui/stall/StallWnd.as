package com.leyou.ui.stall {
	import com.ace.enum.ItemEnum;
	import com.ace.enum.UIEnum;
	import com.ace.game.backpack.GridBase;
	import com.ace.game.manager.DragManager;
	import com.ace.game.scene.part.LivingModel;
	import com.ace.gameData.backPack.TClientItem;
	import com.ace.gameData.player.MyInfoManager;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.input.children.TextInput;
	import com.ace.ui.scrollPane.children.ScrollPane;
	import com.ace.ui.window.children.AlertWindow;
	import com.leyou.manager.UIManager;
	import com.leyou.net.protocol.Cmd_Chat;
	import com.leyou.net.protocol.Cmd_Stall;
	import com.leyou.ui.stall.child.StallListRender;

	import flash.events.MouseEvent;

	public class StallWnd extends AutoWindow {
		private var confirmBtn:NormalButton;
		private var stallInput:TextInput;

		private var scrollContent:ScrollPane;

		public var itemRenderArr:Vector.<StallListRender>;
		private var itemSelfDataArr:Vector.<TClientItem>;

		public var itemOtherDataArr:Vector.<TClientItem>;

		public var selectPlayerID:int=-1;

		public function StallWnd() {
			super(LibManager.getInstance().getXML("config/ui/StallWnd.xml"));
			this.init();
		}

		private function init():void {
			this.confirmBtn=this.getUIbyID("confirmBtn") as NormalButton;
			this.stallInput=this.getUIbyID("stallInput") as TextInput;

			this.scrollContent=new ScrollPane(330, 350);
			this.scrollContent.x=32;
			this.scrollContent.y=130;

			this.addToPane(scrollContent);

			this.confirmBtn.addEventListener(MouseEvent.CLICK, onBtnClick);

			this.itemRenderArr=new Vector.<StallListRender>;
			this.itemSelfDataArr=new Vector.<TClientItem>;
			this.itemOtherDataArr=new Vector.<TClientItem>;

			var render:StallListRender;
			for (var i:int=0; i < 10; i++) {
				render=new StallListRender;

				if (i % 2 != 0) {
					render.x=render.width + 2;
				}

				render.y=Math.floor(i / 2) * render.height;
				this.scrollContent.addToPane(render);

				this.itemRenderArr.push(render);
			}
		}

		private function updateInfo(vec:Vector.<TClientItem>):void {
			for (var i:int=0; i < this.itemRenderArr.length; i++) {
				if (vec.length > i && vec[i] != null)
					this.itemRenderArr[i].update(vec[i]);
				else
					this.itemRenderArr[i].update(null);
			}
		}

		private function onBtnClick(evt:MouseEvent):void {
			if (evt.target.name == "confirmBtn") { //确定按钮
				if (this.stallInput.text != null && this.stallInput.text != "") {
					if (this.itemSelfDataArr.length == 0) {
						AlertWindow.showWin("你没有物品!");
						return;
					}
					Cmd_Stall.cm_btItem_confirm(this.stallInput.text);
					UIManager.getInstance().backPackWnd.hide();
					this.confirmBtn.setActive(false);
				} else
					AlertWindow.showWin("请输入名字!");
			}
		}

		override public function hide():void {
			super.hide();

			if (this.itemOtherDataArr.length == 0)
				Cmd_Stall.cm_canclebtitem();

			this.itemSelfDataArr.length=0;
			this.itemOtherDataArr.length=0;
			this.confirmBtn.setActive(true);
		}

		/**
		 * 添加物品
		 */
		public function serv_addItemGrid():void {
			if (MyInfoManager.getInstance().waitItemFromId == -1)
				return;

			var g:GridBase=DragManager.getInstance().getGrid(ItemEnum.TYPE_GRID_BACKPACK, MyInfoManager.getInstance().waitItemFromId);
			g.enable=true;
			this.itemSelfDataArr.push(g.data);

			this.updateInfo(this.itemSelfDataArr);
			MyInfoManager.getInstance().resetItem(g.dataId);
			UIManager.getInstance().backPackWnd.refresh();
			MyInfoManager.getInstance().waitItemFromId=-1;
		}

		/**
		 *删除自己的物品
		 * @param info
		 *
		 */
		public function serv_removeItem(info:TClientItem):void {
			if (info == null)
				return;

			this.itemSelfDataArr.splice(getItemSelfDataArrIndex(info.MakeIndex), 1);
			this.updateInfo(this.itemSelfDataArr);
		}

		public function getItemSelfDataArrIndex(mkindex:uint):int {
			for (var i:int=0; i < this.itemSelfDataArr.length; i++) {
				if (this.itemSelfDataArr[i].MakeIndex == mkindex)
					return i;
			}

			return -1;
		}

		/**
		 *	显示panel
		 */
		public function serv_showStall():void {
			if (MyInfoManager.getInstance().isOnMount) {
				Cmd_Chat.cm_say("@下马");
			}

			super.show();
			UIManager.getInstance().backPackWnd.show();
			UIManager.getInstance().backPackWnd.x=(UIEnum.WIDTH - UIManager.getInstance().backPackWnd.width - this.width) / 2;
			this.x=UIManager.getInstance().backPackWnd.x + UIManager.getInstance().backPackWnd.width;

			this.confirmBtn.visible=true;
			this.updateInfo(itemSelfDataArr);
			this.stallInput.text=MyInfoManager.getInstance().name + "-摊位";

			//锁定人物;

		}

		/**
		 * 显示其他玩家
		 *
		 */
		public function serv_showOthStall():void {

			if (this.itemOtherDataArr.length == 0) {
				super.hide();
				return;
			}

			super.show();
			this.updateInfo(itemOtherDataArr);
			this.confirmBtn.visible=false;

			var player:LivingModel=UIManager.getInstance().mirScene.getPlayer(selectPlayerID);
			if (player != null)
				this.stallInput.text="" + player.infoB.stallName
		}

	}
}