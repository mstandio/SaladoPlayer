/*
Copyright 2012 Marek Standio.

This file is part of SaladoPlayer.

SaladoPlayer is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published
by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.

SaladoPlayer is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty
of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with SaladoPlayer. If not, see <http://www.gnu.org/licenses/>.
*/
package com.panozona.modules.infobox.model {
	
	import com.panozona.modules.infobox.events.ViewerEvent;
	import com.panozona.modules.infobox.model.structure.Article;
	import com.panozona.modules.infobox.model.structure.Articles;
	import com.panozona.modules.infobox.model.structure.Viewer;
	import flash.events.EventDispatcher;
	
	public class ViewerData extends EventDispatcher{
		
		public const viewer:Viewer = new Viewer();
		public const articles:Articles = new Articles();
		
		public const scrollBarData:ScrollBarData = new ScrollBarData();
		
		private var _currentArticleId:String;
		private var _textHeight:Number;
		
		public function getArticleById(articleId:String):Article {
			for each(var article:Article in articles.getChildrenOfGivenClass(Article)) {
				if (article.id == articleId) return article;
			}
			return null;
		}
		
		public function get currentArticleId():String {return _currentArticleId;}
		public function set currentArticleId(value:String):void {
			if (value == null || value == _currentArticleId) return;
			_currentArticleId = value;
			dispatchEvent(new ViewerEvent(ViewerEvent.CHANGED_CURRENT_ARTICLE_ID));
		}
		
		public function get textHeight():Number {return _textHeight;}
		public function set textHeight(value:Number):void {
			if (value == _textHeight) return;
			_textHeight = value;
			dispatchEvent(new ViewerEvent(ViewerEvent.CHANGED_TEXT_HEIGHT));
		}
	}
}