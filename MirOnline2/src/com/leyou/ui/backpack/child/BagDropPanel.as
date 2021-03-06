package com.leyou.ui.backpack.child {
	import com.ace.game.backpack.GridBase;
	import com.ace.gameData.backPack.TClientItem;
	import com.ace.manager.LibManager;
	import com.ace.ui.auto.AutoWindow;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.lable.Label;
	import com.leyou.net.protocol.Cmd_backPack;
	
	import flash.events.MouseEvent;

	public class BagDropPanel extends AutoWindow {
		private var dropBtn:NormalButton;
		private var saveBtn:NormalButton;

		private var itemName:Label;

		private var itemGrid:BackpackGrid;
		private var info:GridBase;

		public function BagDropPanel() {
			super(LibManager.getInstance().getXML("config/ui/backPack/MessageWnd04.xml"));
			this.init();
		}

		private function init():void {
			this.dropBtn=this.getUIbyID("confirmBtn") as NormalButton;
			this.saveBtn=this.getUIbyID("cancelBtn") as NormalButton;
			this.itemName=this.getUIbyID("nameLbl") as Label;

			this.dropBtn.addEventListener(MouseEvent.CLICK, onClick);
			this.saveBtn.addEventListener(MouseEvent.CLICK, onClick);

			this.itemGrid=new BackpackGrid(-1);
			this.addChild(this.itemGrid);

			this.itemGrid.mouseChildren=false;
			this.itemGrid.mouseEnabled=false;
			
			this.itemGrid.x=30;
			this.itemGrid.y=60;
		}

		private function update(info:TClientItem):void {
			this.itemGrid.updataInfo(info);
			this.itemName.text=info.s.name + "";
		}

		public function showPanel(info:GridBase):void {
			super.show();
			update(info.data as TClientItem);
			this.info=info;
			info.enable=false;
		}

		private function onClick(e:MouseEvent):void {
			switch (e.target.name) {
				case "confirmBtn":
					if (this.info != null && this.info.data!=null || this.info.data.s!=null)
						Cmd_backPack.cm_dropItem(TClientItem(this.info.data).MakeIndex, this.itemName.text);
					break;
				case "cancelBtn":
					
					break;
			}
			this.hide();
			this.info.enable=true;
		}

	}
}
