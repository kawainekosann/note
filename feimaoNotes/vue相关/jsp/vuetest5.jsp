<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<div id='app16'>
	<button @click="change">切换页面</button>
	<component :is="currentTabComponent" v-for="post in posts" :post="post"
		AAA='asdasd'></component>
</div>

<script>
	var componenta = Vue.component("component_a", {
		props : [ 'post' ],
		template : '<div>我是A页:{{post.title}}</div>'
	});
	var componentb = Vue.component("component_b", {
		props : {
			post : {
				type : Object
			},
			aaa : [ String, Number ]
		},
		template : '<div>我是B页:{{post.title}}{{aaa}}</div>'
	});
	var componentc = Vue.component("component_c", {
		props : [ 'post' ],
		template : '<div>我是C页:{{post.title}}</div>'
	});

	var app16 = new Vue({
		el : "#app16",
		components : {
			'component_a' : componenta,
			'component_b' : componentb,
			'component_c' : componentc
		},
		data : {
			posts : [ {
				id : 1,
				title : 'My journey with Vue'
			}, {
				id : 2,
				title : 'Blogging with Vue'
			}, {
				id : 3,
				title : 'Why Vue is so fun'
			} ],
			currentTabComponent : 'component_c'
		},
		methods : {
			change : function() {
				this.currentTabComponent = 'component_b';
			}
		}
	});
</script>