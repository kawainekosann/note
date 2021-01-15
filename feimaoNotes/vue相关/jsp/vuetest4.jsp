<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<div id='app15'>
	<input v-model="message" placeholder="edit me">
	<p>Message is: {{ message }}</p>
	<span>Multiline message is:</span>
	<p style="white-space: pre-line;">{{ message2 }}</p>
	<br>
	<textarea v-model="message2" placeholder="add multiple lines"></textarea>
	<input type="checkbox" id="checkbox" v-model="checked"> <label
		for="checkbox">{{ checked }}</label> <br> <input type="checkbox"
		id="jack" value="Jack" v-model="checkedNames"> <label
		for="jack">Jack</label> <input type="checkbox" id="john" value="John"
		v-model="checkedNames"> <label for="john">John</label> <input
		type="checkbox" id="mike" value="Mike" v-model="checkedNames">
	<label for="mike">Mike</label> <br> <span>Checked names: {{
		checkedNames }}</span>
</div>

<div id="example-4">
	<input type="radio" id="one" value="One" v-model="picked"> <label
		for="one">One</label> <br> <input type="radio" id="two"
		value="Two" v-model="picked"> <label for="two">Two</label> <br>
	<span>Picked: {{ picked }}</span>
</div>
<div id="example-5">
	<select v-model="selected">
		<option disabled value="">请选择</option>
		<option>A</option>
		<option>B</option>
		<option>C</option>
	</select> <span>Selected: {{ selected }}</span>
</div>
<div id="example-6">
	<select v-model="selected" multiple style="width: 50px;">
		<option>A</option>
		<option>B</option>
		<option>C</option>
	</select> <br> <span>Selected: {{ selected }}</span>
</div>
<div id="components-demo">
	<button-counter></button-counter>
	<button-counter></button-counter>
	<button-counter></button-counter>
	<blog-post title="My journey with Vue"></blog-post>
	<blog-post title="Blogging with Vue"></blog-post>
	<blog-post title="Why Vue is so fun"></blog-post>
</div>

<div id='blog-post-demo'>
	<blog-post v-for="post in posts" v-bind:key="post.id"
		v-bind:title="post.title"></blog-post>
</div>
liuliuliuliuliu
<div id="blog-posts-events-demo">
	<div :style="{ fontSize: postFontSize + 'em' }">
		<blog-post2 v-for="post in posts" v-bind:key="post.id"
			v-bind:post="post" v-on:enlarge-text="onEnlargeText">kawainekosann</blog-post2>
	</div>
</div>


<div id="example">
	<button @click="change">切换页面</button>
	<component :is="currentView"></component>
</div>
<script>
	new Vue({
		el : '#app15',
		data : {
			message : 'msg1',
			message2 : 'msg2',
			checked : true,
			checkedNames : []
		}
	});
	new Vue({
		el : '#example-4',
		data : {
			picked : ''
		}
	});
	new Vue({
		el : '#example-5',
		data : {
			selected : ''
		}
	});
	new Vue({
		el : '#example-6',
		data : {
			selected : []
		}
	})
	Vue.component('blog-post', {
		props : [ 'title' ],
		template : '<h3>{{ title }}</h3>'
	});
	Vue
			.component(
					'button-counter',
					{
						data : function() {
							return {
								count : 0
							}
						},
						template : '<button v-on:click="count++">You clicked me {{ count }} times.</button>'
					});
	new Vue({
		el : '#components-demo'
	});
	new Vue({
		el : '#blog-post-demo',
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
			} ]
		}
	});

	Vue
			.component(
					'blog-post2',
					{
						props : [ 'post' ],
						template : '<div class="blog-post"><h3>{{ post.title }}</h3><button v-on:click="$emit(\'enlarge-text\')"><slot></slot>Enlarge text</button><div v-html="post.content"></div></div>'
					})
	new Vue({
		el : '#blog-posts-events-demo',
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
			postFontSize : 1,
			enlargeAmount : 0.1
		},
		methods : {
			onEnlargeText : function(enlargeAmount) {
				this.postFontSize += this.enlargeAmount
			}
		}
	})

	var home = {
		template : '<div>我是主页</div>'
	};
	var post = {
		template : '<div>我是提交页</div>'
	};
	var archive = {
		template : '<div>我是存档页</div>'
	};
	new Vue({
		el : '#example',
		components : {
			"home" : home,
			"post" : post,
			"archive" : archive,
		},
		data : {
			index : 0,
			arr : [ 'home', 'post', 'archive' ],
		},
		computed : {
			currentView : function() {
				return this.arr[this.index];
			}
		},
		methods : {
			change : function() {
				this.index = (++this.index) % 3;
			}
		}
	})
</script>