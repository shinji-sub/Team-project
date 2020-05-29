<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="../room/room_header.jsp" />

<div class="container-fluid" style='margin-top:8em; display:flex;'>
<aside id='lesson_aside'>
<div id="alarm_box">
       <i class="fas fa-lightbulb text-warning"></i>
       <!-- <span class="badge badge-warning">알림 상자</span> -->
  <ul id="alarm_contents">
     <li v-for="item in items" v-if="dateConfigure(item.deadline)">
       <span v-if="item.hasOwnProperty('questionNo')">
         <a v-bind:href="`../question/detail?qno=`+item.questionNo">
         <span class="alarm_box__icon"><i class="fas fa-question-circle"></i></span>
           <span title='마감일이 임박했습니다.'>{{ item["title"] }}</span>
         </a>
       </span>
       <span v-if="item.hasOwnProperty('assignmentNo')">
       <a v-bind:href="`../assignment/detail?assignmentNo=`+ item.assignmentNo">
        <span class="alarm_box__icon"><i class="fas fa-pen-square"></i></span>
        <span title='마감일이 임박했습니다.'>{{ item["title"] }}</span>
       </a>
       </span>
     </li>
  </ul>
</div>
  <form id="filter">
    <select onclick="activeFilter(this.value)">
      <option value="0">전체</option>
      <option value="1">과제</option>
      <option value="2">질문</option>
    </select>
  </form>
</aside>
<section id='lesson_section'>
<div id='lesson_section_add'>
  <div id='lesson__create-div' onclick='lessonAddActive()'>
    <i class="fas fa-plus"></i>만들기
  </div>
	<div id='lessonAddActiveDiv' style='display:none;'>
		<div onclick='location.href="../assignment/form"' onmouseover='this.style.backgroundColor="#b3ecff"'
		onmouseleave='this.style.backgroundColor="white"' id="assignment_add_btn" >
			<i class="fas fa-pen-square"></i>과제 추가
	 </div>
		<div onclick='location.href="../question/form"'onmouseover='this.style.backgroundColor="#b3ecff"'
    onmouseleave='this.style.backgroundColor="white"' id="question_add_btn">
		  <i class="fas fa-question-circle"></i>질문 추가
		</div>
	</div>
</div>
<div id="lesson_box">
	<ul id="lesson_contents">
	  <li v-for="item in items" v-if="item.hasOwnProperty('questionNo')">
      <a v-bind:href="`../question/detail?qno=`+item.questionNo">	   
  	    <i class="fas fa-question-circle"></i><span>{{ item["title"] }}</span>
	    </a>
	  </li>
	  <li v-for="item in items" v-if="item.hasOwnProperty('assignmentNo')">
	   <a v-bind:href="`../assignment/detail?assignmentNo=`+ item.assignmentNo">
        <i class="fas fa-pen-square"></i><span>{{ item["title"] }}</span>
     </a>
    </li>
  </ul>
</div>
</section>

</div>

<script>
//학생이면 만들기 버튼을 숨김
const role = ${nowMember.role};
console.log(role);
if(role !== 0) {
  $('#lesson_section_add').css('display', 'none');
}


var questionJson = '${questionJson}';
var assignmentJson = '${assignmentJson}';

//서버로부터 받은 자료
let questions = JSON.parse(decodeURIComponent(questionJson).replace(/\+/g," "));
let assignments = JSON.parse(decodeURIComponent(assignmentJson).replace(/\+/g," "));
let all = questions.concat(assignments);

//생성일 순으로 정렬
let sortingField = "createDate";
all.sort(function(a,b) {
  return b[sortingField] - a[sortingField];
});
console.log(all);

// 레슨 템플릿
var lesson_contents = new Vue({
	  el: '#lesson_contents',
	  data: {
	    items: all
	  }
	})

// 알림 템플릿
var alarm_contents = new Vue({
    el: '#alarm_contents',
    data: {
      items: all
    },
    methods: {
    	dateConfigure(deadline) {
    	    if(deadline - Date.now() < 172800000 && deadline - Date.now() > 0) {
    	      return true;
    	    } else {
    	      return false;
    	    }
    	}
    }
  })


// 필터 선택에 따라 작업하는 함수	
function activeFilter(value) {
	if(value == 0) {
		lesson_contents.items = all;
	}
	if(value == 1) {
		lesson_contents.items = all.filter(function (item) {
		    return item.hasOwnProperty('assignmentNo');
		  })
	}
	if(value == 2) {
		lesson_contents.items = all.filter(function (item) {
			  		return item.hasOwnProperty('questionNo');
	      })
	}
	
}	

  </script>
  <script>
  let lessonAddActiveStatus = 0;
  function lessonAddActive() {
      if(lessonAddActiveStatus == 0) {
	      lessonAddActiveStatus = 1;
	      $('#lessonAddActiveDiv').css('display', '');
      } else {
	      lessonAddActiveStatus = 0;
	      $('#lessonAddActiveDiv').css('display', 'none');
      }
      
  }
  </script>

</body>
</html>

