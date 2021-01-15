<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<div id="app11">
	<p v-if="seen">现在你可以看到我了</p>
	<a v-on:click="doSomething"><font v-bind:color="color">链接</font></a> <a
		v-bind:[attribute]="url"> 链接2 </a>
	<p>dosomething: "{{ doSomething() }}"</p>
	<p>Computed reversed message: "{{ reversedMessage }}"</p>
</div>
<div id="watch-example">
	<p>
		Ask a yes/no question: <input v-model="question">
	</p>
	<p>{{ answer }}</p>
</div>

<div id='app12' class="static"
	v-bind:class="{ active: isActive, 'text-danger': hasError }">
	asd
	<div v-bind:class="classObject"></div>
</div>
<script
	src="https://cdn.jsdelivr.net/npm/axios@0.12.0/dist/axios.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/lodash@4.13.1/lodash.min.js"></script>
<script>
	var app11 = new Vue({
		el : "#app11",
		data : {
			seen : true,
			color : 'red',
			attribute : 'href',
			url : 'www.baidu.com'
		},
		methods : {
			doSomething : function() {
				//this.color = 'green',
				this.url = 'www.nekokawai.com'
			}
		},
		computed : {
			// 计算属性的 getter
			reversedMessage : function() {
				// `this` 指向 vm 实例
				return this.color.split('').reverse().join('')
			}
		},
		watch : {
			color : function(val) {
				if (this.color == 'green') {
					this.seen = false
				}
			}
		}

	});
	var watchExampleVM = new Vue({
		  el: '#watch-example',
		  data: {
		    question: '',
		    answer: 'I cannot give you an answer until you ask a question!'
		  },
		  watch: {
		    // 如果 `question` 发生改变，这个函数就会运行
		    question: function (newQuestion, oldQuestion) {
		      this.answer = 'Waiting for you to stop typing...'
		      this.debouncedGetAnswer()
		    }
		  },
		  created: function () {
		    // `_.debounce` 是一个通过 Lodash 限制操作频率的函数。
		    // 在这个例子中，我们希望限制访问 yesno.wtf/api 的频率
		    // AJAX 请求直到用户输入完毕才会发出。想要了解更多关于
		    // `_.debounce` 函数 (及其近亲 `_.throttle`) 的知识，
		    // 请参考：https://lodash.com/docs#debounce
		    this.debouncedGetAnswer = _.debounce(this.getAnswer, 500)
		  },
		  methods: {
		    getAnswer: function () {
		      if (this.question.indexOf('?') === -1) {
		        this.answer = 'Questions usually contain a question mark. ;-)'
		        return
		      }
		      this.answer = 'Thinking...'
		      var vm = this
		      axios.get('https://yesno.wtf/api')
		        .then(function (response) {
		          vm.answer = _.capitalize(response.data.answer)
		        })
		        .catch(function (error) {
		          vm.answer = 'Error! Could not reach the API. ' + error
		        })
		    }
		  }
		});
		var app12 = new Vue({
			el : "#app12",
			data: {
				isActive: true,
				hasError: false,
				/* classObject: {
				    active: true,
				    'text-danger': true
				  } */
			},
		computed: {
			  classObject: function () {
			    return {
			      active: this.isActive && !this.hasError,
			      'text-danger': this.hasError && this.hasError.type === 'fatal'
			    }
			  }
			}
		});
</script>