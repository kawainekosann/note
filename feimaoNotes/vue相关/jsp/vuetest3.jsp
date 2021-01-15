<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<script>
	Vue.component('my-component', {
		template : '<p class="foo bar">Hi</p>'
	})
</script>

<div id='app13' v-bind:class="[isActive ? activeClass : '', errorClass]">
	<div v-bind:class="[{ active: isActive }, errorClass]"></div>
	<div v-bind:style="[styleObject,stylea]">kakaka</div>
	<my-component class="baz boo" v-bind:class="{ active: isActive }"
		v-bind:style="{ color: activeColor, fontSize: fontSize + 'px' }"></my-component>
	<h1 v-if="awesome">Vue is awesome!</h1>
	<h1 v-else>Oh no 😢</h1>
	<template v-if="loginType === 'username'"> <label>Username</label>
	<input placeholder="Enter your username" key="username-input">
	</template>
	<template v-else> <label>Email</label> <input
		placeholder="Enter your email address" key="email-input"> </template>
	<template v-if="ok">
	<h1>Title</h1>
	<p>Paragraph 1</p>
	<p>Paragraph 2</p>
	</template>
	<div v-if="Math.random() > 0.5">Now you see me</div>
	<div v-else>Now you don't</div>
	<h1 v-show="ok">Hello!</h1>
</div>
<div id="example-1">
	<button v-on:click="counter += 1">Add 1</button>
	<p>The button above has been clicked {{counter}}times.</p>
</div>
<div id='app14'>
	<ul id="example-1">
		<li v-for="(item, index) in items">{{ parentMessage }} - {{ index
			}} - {{ item.message }}</li>
	</ul>
	<div v-for="(value, name, index) in object">{{ index }}. {{ name
		}}: {{ value }}</div>
	<div v-for="n in evenNumbers">{{ n }}</div>
	<ul v-for="set in sets">
		<li v-for="n in even(set)">{{ n }}</li>
	</ul>
	<span v-for="n in 10">{{ n }} </span>
	<!-- <ul>
		<template v-for="item in items">
		<li>{{ item.message }}</li>
		<li class="divider" role="presentation"></li>
		</template>
	</ul> -->
	<my-component1 v-for="item in items" :key="item.id" v-bind:todo="item">
	</my-component1>
</div>
<div id="example-2">
	<!-- `greet` 是在下面定义的方法名 -->
	<button v-on:click="greet">Greet</button>
</div>
<div id="example-3">
	<button v-on:click="say('hi')">Say hi</button>
	<button v-on:click="say('what')">Say what</button>
</div>
<script>
	var app13 = new Vue({
		el : '#app13',
		data : {
			isActive : false,
			activeClass : 'active',
			errorClass : 'text-danger',
			activeColor : 'blue',
			fontSize : 10,
			ok : false,
			styleObject : {
				color : 'red'
			},
			stylea : {
				fontSize : '14px'
			},
			awesome : true,
			loginType : 'username'

		}
	});

	Vue.component('my-component1', {
		props : [ 'todo' ],
		template : '<li>{{ todo.message }}</li>'
	});
	var app14 = new Vue({
		el : '#app14',
		data : {
			parentMessage : 'Parent',
			items : [ {
				message : 'Foo'
			}, {
				message : 'Bar'
			} ],
			object : {
				author : 'Jane Doe',
				title : 'How to do lists in Vue',
				publishedAt : '2016-04-10'
			},
			numbers : [ 1, 2, 3, 4, 5 ],
			sets : [ [ 1, 2, 3, 4, 5 ], [ 6, 7, 8, 9, 10 ] ]
		},
		computed : {
			evenNumbers : function() {
				return this.numbers.filter(function(number) {
					return number % 2 === 0
				})
			}
		},
		methods : {
			even : function(numbers) {
				return numbers.filter(function(number) {
					return number % 2 === 0
				})
			}
		}
	});

	var example1 = new Vue({
		el : '#example-1',
		data : {
			counter : 0
		}
	});

	var example2 = new Vue({
		el : '#example-2',
		data : {
			name : 'Vue.js'
		},
		// 在 `methods` 对象中定义方法
		methods : {
			greet : function(event) {
				// `this` 在方法里指向当前 Vue 实例
				alert('Hello ' + this.name + '!')
				// `event` 是原生 DOM 事件
				if (event) {
					alert(event.target.tagName)
				}
			}
		}
	});
	new Vue({
		el : '#example-3',
		methods : {
			say : function(message) {
				alert(message)
			}
		}
	})
</script>