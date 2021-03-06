package com.leyou.manager {
	import com.ace.ICommon.IMenu;
	import com.ace.ui.button.children.NormalButton;
	import com.ace.ui.menu.MenuButton;
	import com.ace.ui.menu.data.MenuInfo;
	import com.leyou.ui.backpack.child.BackpackGrid;
	import com.leyou.ui.guild.child.children.GuildStoreGrid;
	import com.leyou.ui.guild.child.children.MemberRender;
	import com.leyou.ui.team.child.TeamListRender;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class MenuManager {
		private static var instance:MenuManager;

		private var stg:Sprite; //菜单容器
		private var currentMenus:Vector.<MenuInfo>; //当前菜单s
		private var currentIMenu:IMenu; //当前单击的菜单

		public static function getInstance():MenuManager {
			if (!instance)
				instance=new MenuManager();

			return instance;
		}

		public function MenuManager() {

		}

		public function setup($stg:Sprite):void {
			this.stg=$stg;
			this.init();
		}

		//ui初始化
		private function init():void {
			this.stg.addEventListener(MouseEvent.CLICK, onMenuClick);
			this.stg.addEventListener(MouseEvent.ROLL_OUT, onMenuOut);
			this.stg.stage.addEventListener(MouseEvent.CLICK, onMenuStageClick);
		}

		private function onMenuOut(e:MouseEvent):void {
			this.stg.visible=false;
		}

		private function onMenuStageClick(evt:MouseEvent):void {
			//注意
			if (!(evt.target is MenuButton) && !(evt.target is BackpackGrid) && !(evt.target is MemberRender) && !(evt.target is GuildStoreGrid) && !(evt.target is TeamListRender))
				this.stg.visible=false;
		}

		private function onMenuClick(evt:MouseEvent):void {
			if (evt.target is MenuButton) {
				this.currentIMenu.onMenuClick(MenuButton(evt.target).index);
			}
			evt.stopImmediatePropagation();
			this.stg.visible=false;
		}

		//要现实的内容,i接口
		public function show(info:Vector.<MenuInfo>, iMenu:IMenu, pt:Point):void {
			this.currentMenus=info;
			this.currentIMenu=iMenu;

			updateButton();

			this.stg.visible=true;

			this.stg.x=pt.x;
			this.stg.y=pt.y;
		}

		public function visible(_b:Boolean=true):void {
			this.stg.visible=_b;
		}

		private function updateButton():void {
			while (this.stg.numChildren) {
				this.stg.removeChildAt(0);
			}

			var btn:MenuButton;
			for (var i:int=0; i < this.currentMenus.length; i++) {
				btn=new MenuButton(this.currentMenus[i].menuName, this.currentMenus[i].menuIndex);
				this.stg.addChild(btn);

				btn.y=i * btn.height;
			}
		}

	}
}

/*
 *
	负责右键菜单
1：单击时显示隐藏
2：鼠标移除菜单后隐藏
3：单击菜单时回调

*/
