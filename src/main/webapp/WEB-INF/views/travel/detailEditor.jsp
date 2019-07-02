<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>TI - detailEditor</title>
<link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
<script src="https://cdn.quilljs.com/1.3.6/quill.js"></script>
<style>
	.card-header {
		background:#AFDCF5;
	}
</style>
</head>
<body>
	<div class="columns">
		<div class="column is-3">
			<section class="section">
				<aside class="menu" id="daySideMenu">
					<p class="menu-label">일자별 상세글</p>
					<ul class="menu-list" id="daySideMenu">
						<c:forEach var="trvDay" items="${ trvDayList }" varStatus="st">
							<c:if test="${ st.index eq 0 }" >
								<li><a class="is-active"><strong>DAY ${ trvDay.dayNumber }</strong></a></li>
							</c:if>
							<c:if test="${ st.index ne 0 }" >
								<li><a><strong>DAY ${ trvDay.dayNumber }</strong></a></li>
							</c:if>
						</c:forEach>
					</ul>
					<p class="menu-label">사진 갤러리</p>
					<ul class="menu-list" id="gallarySideMenu">
						<li><a>전체보기</a></li>
						<li><a>일자별 모아보기</a>
							<ul>
								<c:forEach var="trvDay" items="${ trvDayList }" varStatus="st">
									<li><a>DAY ${ trvDay.dayNumber }</a></li>
								</c:forEach>
							</ul>
						</li>
					</ul>
				</aside>
			</section>
		</div>
		<div class="column is-9">
			<c:forEach var="trvDay" items="${ trvDayList }" varStatus="st">
				<div class="dayHeader" id="day${ trvDay.dayNumber }Header" style="display:none">
					<section class="section" style="padding-bottom:10px">
						<nav class="level">
							<div class="level-left">
								<div class="level-item">
									<p class="subtitle is-3">
										<strong>DAY ${ trvDay.dayNumber }</strong> 
									</p>
									<p class="help">${ trvDay.dayDate }</p>
								</div>
								<div class="level-item">
									<div class="field">
										<p class="control">
											<input type="hidden" value="${ trvDay.dayId }">
											<input class="input dayMemo day${ trvDay.dayId }Memo" type="text" placeholder="MEMO" value="${ trvDay.dayMemo }" 
											style="width:100%">
										</p>
									</div>
								</div>
							</div>
							<div class="level-right" id="weatherArea">
								<p class="level-item" style="margin:0 10px 0 0">
									<a class="button is-danger is-outlined weatherBtn">
										<span class="icon">
											<i class="fas fa-sun"></i>
										</span>
									</a>
								</p>
								<p class="level-item" style="margin:0 10px 0 0">
									<a class="button is-dark is-outlined weatherBtn">
										<span class="icon">
											<i class="fas fa-cloud"></i>
										</span>
									</a>
								</p>
								<p class="level-item" style="margin:0 10px 0 0">
									<a class="button is-info is-outlined weatherBtn">
										<span class="icon">
											<i class="fas fa-umbrella"></i>
										</span>
									</a>
								</p>
								<p class="level-item" style="margin:0 10px 0 0">
									<a class="button is-primary is-outlined weatherBtn">
										<span class="icon">
											<i class="far fa-snowflake"></i>
										</span>
									</a>
								</p>
								<p class="level-item" style="margin:0 10px 0 0">
									<a class="button is-warning is-outlined weatherBtn">
										<span class="icon">
											<i class="fas fa-bolt"></i>
										</span>
									</a>
								</p>
							</div>
						</nav>
						<hr style="border:1px solid lightgray">
					</section>
				</div>
				<div class="dayArea" id="day${ trvDay.dayNumber }Area" style="display:none">
					<c:forEach var="sch" items="${ trvDay.schList }" varStatus="st" >
						<section class="section">
							<div class="card">
								<header class="card-header">
									<p class="icon is-large" style="color:#8e44ad; margin:5px">
										<i class="fas fa-2x fa-bookmark"></i>
									</p>
									<div class="card-header-title" style="display:block">
										<p><strong>${ sch.schTitle }</strong></p>
										<p class="help">
											<c:if test="${ !empty sch.trvCost }">
												${ sch.trvCost.costType } :<strong>${ sch.trvCost.costAmount }</strong> 
												(${ sch.trvCost.currency }) / 
											</c:if>&nbsp;&nbsp;&nbsp;
											${ sch.schTransp }
										</p> 
										<small> 
											<a style="color: purple"> 
												<span class="icon is-small" style="color: purple"> 
													<i class="fas fa-map-marker-alt"></i>
												</span> 
												<c:if test="${ sch.plcName ne null }">
													${ sch.plcName }
												</c:if> 
												<c:if test="${ sch.plcName eq null }">
													(장소 정보 없음)
												</c:if>
											</a>
										</small> 
									</div>
									<a class="card-header-icon">
										<span class="icon detailEditBtn" 
										style="color:#8e44ad; margin-right:10px; width:100px">
											작성하기
											<i class="fas fa-2x fa-pencil-alt"></i>
										</span>
										<span class="icon detailShowBtn"><i class="fa fa-angle-down"></i></span>
									</a>
								</header>
								<div class="card-content" style="display:none">
									<div class="content editor"></div>
								</div>
								<footer class="card-footer" style="display:none">
									<a class="card-footer-item" style="background:mediumpurple;color:white">Save</a> 
									<a class="card-footer-item" style="background:skyblue;color:white">Edit</a>
									<a class="card-footer-item" style="background:lightgray;color:white">Delete</a>
								</footer>
							</div>
						</section>
					</c:forEach>
				</div>
			
				<div class="gallaryArea" id="gallary${ trvDay.dayNumber }Area" style="display:none">	
					<section class="section">
						<div class="columns">
							<% for(int i = 1; i <= 3; i++) { %>
							<div class="column is-one-third">
								<div class="card trvCard">
									<div class="card-image">
										<figure class="image" style="margin:0">
											<img src="resources/images/sample1.jpg">
										</figure>
									</div>
									<div class="card-content">
										<div class="content" align="right">
											${ trvDay.dayDate }
										</div>
										<div class="content">
											<p>사진<%= i %></p>
										</div>
									</div>
								</div>
							</div>
							<% } %>
						</div>
					</section>
				</div>		
			</c:forEach>
		</div>
	</div>
	
	<script>
	
		$(function() {
			$("#day1Header").show();
			$("#day1Area").show();
			$("#daySideMenu>li").click(function() {
				var day = $(this).children("a").text();
				
				$(this).children("a").addClass('is-active');
				$(this).siblings().children("a").removeClass('is-active');
				$("#gallarySideMenu li>a").removeClass('is-active');
				$(".dayArea, .gallaryArea, .dayHeader").hide();
				$("#day" + day.charAt(4) + "Header").show();
				$("#day" + day.charAt(4) + "Area").show();
			});
			$("#gallarySideMenu>li:first").click(function() {
				$("#gallarySideMenu>li>ul>li").children("a").removeClass('is-active');
				$(this).children("a").addClass('is-active');
				$("#daySideMenu>li").children("a").removeClass('is-active');
				$(".dayArea").hide();
				$(".dayHeader").show();
				$(".gallaryArea").show();
			});
			$("#gallarySideMenu>li>ul>li").click(function() {
				var day = $(this).children("a").text();
				$("#gallarySideMenu>li:first").children("a").removeClass('is-active');
				$(this).children("a").addClass('is-active');
				$(this).siblings().children("a").removeClass('is-active');
				$("#daySideMenu>li").children("a").removeClass('is-active');
				$("#gallarySideMenu li>a").removeClass('is-active');
				$(".dayArea, .gallaryArea, .dayHeader").hide();
				$("#day" + day.charAt(4) + "Header").show();
				$("#gallary" + day.charAt(4) + "Area").show();
			});
			
			
			var toolbarOptions = [ 
				[ 'bold', 'italic', 'underline', 'strike' ], // toggled buttons
				[ 'blockquote', 'code-block' ],

				[ { 'header' : 1}, {'header' : 2} ], // custom button values
				[ {'list' : 'ordered'}, {'list' : 'bullet'} ], [ {'script' : 'sub'}, {'script' : 'super'} ], // superscript/subscript
				[ {'direction' : 'rtl'} ], // text direction

				[ {'header' : [ 1, 2, 3, 4, 5, 6, false ]} ],

				[ {'color' : []}, {'background' : []} ], // dropdown with defaults from theme
				[ {'font' : []} ], [ {'align' : []} ],

				[ 'link', 'image' ],

				[ 'clean' ] // remove formatting button
			];

			$(".editor").each(function() {
				var container = $(this).get(0);
				var quill = new Quill(container, {
					modules : {
						toolbar : toolbarOptions
					},
					placeholder : '멋진 사진과 함께 여행 후기글을 작성해보세요! ',
					theme : 'snow' // or 'bubble'
				});
				quills.push(quill);
			});
			
			
		});

		var quills = [];
		
		
		
		$(".weatherBtn").click(function() {
			$(this).removeClass('is-outlined');
			$(this).parent().siblings().children().addClass('is-outlined')
		});
		$(".detailShowBtn, .detailEditBtn").click(function() {
			$(this).parent().parent().next().toggle();
			$(this).parent().parent().next().next().toggle();
		});
	</script>
</body>
</html>