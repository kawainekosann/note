<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script src="./script/jquery-1.11.1.js"></script>
<script src="./script/jquery-1.11.1.js"></script>
<script src="./script/jquery-ui.js"></script>
<script type="text/javascript" src="./script/ajaxfileupload.js"></script>
<script type="text/javascript" src="./script/jquery.validate.js"></script>
<script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>

<title>Insert title here</title>
</head>

<body>
	<%@include file="./WEB-INF/jsp/vuetest5.jsp"%>
	<%@include file="./WEB-INF/jsp/vuetest4.jsp"%>
	<%@include file="./WEB-INF/jsp/vuetest3.jsp"%>
	<%@include file="./WEB-INF/jsp/vuetest2.jsp"%>
	<div id="app">内容： {{ message }}</div>
	<div id="app2">
		<span v-bind:title="message"> 鼠标悬停几秒钟查看此处动态绑定的提示信息！ </span>
	</div>
	<div id="app3">
		<p v-if="seen">现在你看到我了</p>
	</div>
	<div id="app4">
		<p v-for="ToDo in ToDos">{{ToDo.message}}</p>
	</div>

	<div id="app5">
		<p>{{ message }}</p>
		<button v-on:click='click'>反转消息</button>
	</div>

	<div id="app6">
		{{message}} <input v-model='message'></input>
	</div>

	<div id="app7">
		<ol>
			<!--
      现在我们为每个 todo-item 提供 todo 对象
      todo 对象是变量，即其内容可以是动态的。
      我们也需要为每个组件提供一个“key”，稍后再
      作详细解释。
    -->
			<todo-item v-for="item in groceryList" v-bind:todo="item"
				v-bind:key="item.id"></todo-item>
		</ol>
	</div>

	<div id="app8">
		<p>{{ foo }}</p>
		<!-- 这里的 `foo` 不会更新！ -->
		<button v-on:click="foo = 'baz'">Change it</button>
	</div>

	<div id="app9">
		<P>
			带html <span v-html="content"></span>
		</P>
	</div>
	<div id="app10">
		<input v-bind:id="dynamicId" v-bind:disabled="disabled"
			v-bind:value="value">{{dynamicId+1}}</input>
	</div>
	<script>
		var app = new Vue({
			el : '#app',
			data : {
				message : 'Hello Vue!'
			}
		})

		var app2 = new Vue({
			el : '#app2',
			data : {
				message : '标题'
			}
		});

		var app3 = new Vue({
			el : '#app3',
			data : {
				seen : true
			}
		});

		var app4 = new Vue({
			el : '#app4',
			data : {
				ToDos : [ {
					message : 'A'
				}, {
					message : 'B'
				}, {
					message : 'C'
				}, {
					message : 'D'
				} ]
			}
		});

		var app5 = new Vue({
			el : '#app5',
			data : {
				message : 'Hello Vue!'
			},
			methods : {
				click : function() {
					this.message = this.message.split('').reverse().join('')
				}
			}
		});

		var app6 = new Vue({
			el : '#app6',
			data : {
				message : 'Hello Vue!'
			}
		});

		Vue.component('todo-item', {
			// todo-item 组件现在接受一个
			// "prop"，类似于一个自定义 attribute。
			// 这个 prop 名为 todo。
			props : [ 'todo' ],
			template : '<li>{{ todo.text }}</li>'
		})

		var app7 = new Vue({
			el : '#app7',
			data : {
				groceryList : [ {
					id : 0,
					text : '蔬菜'
				}, {
					id : 1,
					text : '奶酪'
				}, {
					id : 2,
					text : '随便其它什么人吃的东西'
				} ]
			}
		})

		var data = {
			a : 1
		}
		var vm = new Vue({
			data : data
		})

		var obj = {
			foo : 'bar'
		}
		//**阻止修改现有的 property**，也意味着响应系统无法再*追踪*变化
		Object.freeze(obj)

		new Vue({
			el : '#app8',
			data : obj
		})

		new Vue({
			data : {
				a : 1
			},
			created : function() {
				// `this` 指向 vm 实例
				console.log('a is: ' + this.a)
			}
		})
		//控制台输出 => "a is: 1"

		var app9 = new Vue({
			el : '#app9',
			data : {
				content : '<font color = "red">红字</font>'
			}
		});

		var app10 = new Vue({
			el : '#app10',
			data : {
				dynamicId : 10,
				disabled : true,
				value : '号10'
			}
		});
	</script>
</body>
</html>