<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="resources/css/bulmaswatch.min.css">
<link rel="stylesheet" type="text/css" href="resources/css/semantic.min.css">
<link rel="stylesheet" href="resources/css/jquery-ui.theme.min.css">
<link rel="stylesheet" href="resources/css/jquery-ui.structure.min.css">
<link rel="stylesheet" href="resources/css/travel/map-icons.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script src="resources/js/jquery-ui.min.js"></script>
<script src="resources/js/semantic.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
<script defer src="https://use.fontawesome.com/releases/v5.3.1/js/all.js"></script>
<style>
	body {
		overflow-x:visible !important;
	}
	.navbar-item img {
    	max-height: 100% !important;
   	}
	.navbar-burger {
		width:200px !important;
	}
</style>
</head>
<body>
<c:set var = "contextPath" value = "${pageContext.servletContext.contextPath }" scope = "application"/>
	<c:if test="${ empty loginUser || trv.completeDate ne null }" >
		<jsp:forward page="/WEB-INF/views/main/main.jsp"/>
	</c:if>

	<nav class="navbar is-white is-fixed-top" style="border-bottom:1px solid skyblue">
    	<div class="navbar-brand">
    		<div class="navbar-item field is-grouped" style="margin:0">
         		<p class="control">
         			<a class="icon is-rounded is-large" onclick="goToMyTravel();"> 
                        <i class="fas fa-3x fa-chevron-circle-left"></i>
                    </a>
                    
            	</p>
            	<p class="control">
                    <a class="button is-rounded" onclick="showTrvInfoModal();"> 
                        <i class="fas fa-info-circle"></i>
                        <span>여행정보수정</span>
                    </a>
                </p>
                <p class="control">
                    <a class="button is-info is-rounded" onclick="completeTravel();"> 
                        <span>작성완료</span>
                    </a>
                </p>
                <p class="control">
                    <a class="button is-dark is-rounded" onclick="deleteTravel();"> 
                        <span>삭제하기</span>
                    </a>
                </p>
            </div>
            <div class="navbar-item field is-grouped" style="margin:0" id="memberInArea">
      		</div>
         	<div class="navbar-burger burger is-hidden-tablet">
		    	<a class="navbar-item" href="index.jsp"> 
		            <img src="resources/images/logoWide.png" width="120px" height="40px">
		        </a>
         	</div> 
		</div>
      	<div id="mainNav" class="navbar-menu">
      		<div class="navbar-start">
      			
      		</div>
        	<div class="navbar-end">
        		
            	<div class="navbar-brand">
		        	<a class="navbar-item" href="index.jsp"> 
		            	<img src="resources/images/logoWide.png" width="120px" height="40px">
		         	</a>
		        </div>
			</div>
		</div>
	</nav>
	
	<br><br>
	<div class="coumns">
		<div class="column">
			<section class="section" style="padding-bottom:0;">
				<div class="columns">
					<div class="column is-6">
						<h3 class="title is-3">
							<span class="icon" style="color:skyblue">
								<i class="fas fa-plane"></i>
							</span>&nbsp;&nbsp;
							<c:out value="${ trv.trvTitle }" />
						</h3>
						<h6 class="subtitle is-6" style="margin:0">
							<i class="fas fa-map-marker-alt"></i>
							<c:forEach var="trvCity" items="${ trvCityList }" varStatus="st">
								${ trvCity.countryNameKo }&nbsp; ${ trvCity.cityNameKo } 
								<c:if test="${ st.count ne trvCityList.size() }">/</c:if>&nbsp;
							</c:forEach>
							<c:set var="end" value="${ trv.endDate.getTime() }" />
							<c:set var="start" value="${ trv.startDate.getTime() }"	/>
							<c:set var="days" value="${ (end - start) / (1000 * 60 * 60 * 24) }"/>
							&nbsp;&nbsp;
							<span><strong>
								(<fmt:formatNumber value="${ days }" pattern="#" />박 
								<fmt:formatNumber value="${ days + 1 }" pattern="#" />일)</strong></span>
							 <%-- <% ${ days } %> --%>
						</h6>
						<p class="help">
							<c:forEach var="trvCity" items="${ trvCityList }" varStatus="st">
								${ trvCity.cityNameEn }, ${ trvCity.countryNameEn }  
								<c:if test="${ st.count ne trvCityList.size() }">/</c:if>&nbsp;
							</c:forEach>
						</p>
					</div>
					<div class="column is-1">
						<div class="dropdown">
							<div class="navbar-item field dropdown-trigger" id="inviteBtn"
								style="margin: 0" data-tooltip="동행초대" data-variation="mini"
								data-position="right center">
								<p class="control">
									<a class="button is-primary is-rounded" aria-haspopup="true"
										aria-controls="inviteDropdown" style="width: 40px"> <i
										class="fas fa-users"></i>
									</a>
								</p>
							</div>
							<div class="dropdown-menu" id="inviteDropdown" role="menu" style="min-width: 25rem;">
								<div class="dropdown-content">
									<div class="dropdown-item">
										<p>함께 여행하는 동행을 초대해서 일정을 공유하고 같이 작성해보세요!</p>
									</div>
									<hr class="dropdown-divider">
									<div class="dropdown-item">
										<p class="control has-icons-left">
											<span class="icon is-small is-left"> 
												<i class="fas fa-search-plus"></i>
											</span> 
											<input class="input is-rounded" type="text" placeholder="이메일 주소 입력" id="searchComp">
										</p>
										<p>
											<input type="hidden" value="" name="memberId" id="compSearchMemberId"> 
											<span id="compSearchResult"></span>
											<button class="button is-info is-small is-rounded" id="addCompBtn"
											 style="display:none">동행 추가</button>
										</p>
									</div>
									<hr class="dropdown-divider">
									<div class="dropdown-item">
										<table class="table " id="compTable">
											<tbody>
												<tr class="compTr" style="display:none">
													<td width="10%">
														<span class="icon">
															<i class="far fa-user"></i>
														</span>
														<input type="hidden" value="" name="memberId">
													</td>
													<td width="70%"></td>
													<td width="20%">
														<button class="button is-dark is-small compDeleteBtn">삭제</button>
													</td>
												</tr>
												<c:forEach var="trvComp" items="${ trvCompList }" varStatus="st">
													<tr class="compTr">
														<td width="10%">
															<span class="icon">
																<i class="far fa-user"></i>
															</span>
															<input type="hidden" value="${ trvComp.memberId }" name="memberId">
														</td>
														<td width="70%">${ trvComp.email } (${ trvComp.userName })</td>
														<td width="20%">
															<button class="button is-dark is-small compDeleteBtn">삭제</button>
														</td>
													</tr>
												</c:forEach>
											</tbody>
										</table>
									</div>
									<hr class="dropdown-divider">
									<div class="dropdown-item">
										<button class="button is-small closeBtn">닫기</button>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="column" style="line-height:80px;">
						<div class="tabs is-right editorMenu">
						    <ul>
						    	<li class="is-active" >
						        	<a><strong>일정작성</strong></a>
						      	</li> 
						      	<li >
						        	<a><strong>상세글작성</strong></a>
						      	</li>
						      	<li >
						        	<a><strong>일정전체보기</strong></a>
						      	</li>
						      	<li >
						        	<a><strong>가계부</strong></a>
						      	</li>
						    </ul>
						</div>
					</div>
				</div>			
			</section>
		</div>
	</div>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/socket.io/2.2.0/socket.io.dev.js"></script>
	<script>
		var socket = io.connect('http://127.0.0.1:4000');
				
		if(socket !== undefined) {
			console.log('Socket connected');
					
			socket.emit('memberIn', {
				name:"${ loginUser.userName }",
				email:"${ loginUser.email }",
				room:"${ trv.trvId }"
			});
					
			socket.on('updateMemberList', function(data) {
				$("#memberInArea").empty();
				for(var key in data) {
					var a = "<p class='control'><a class='button is-success' data-tooltip='" + data[key].email + "(" + data[key].name + ")' data-variation='mini'" 
						+ " data-position='left center'>" + data[key].name.charAt(0) + '</a></p>';
					$("#memberInArea").append(a);
				}
			});
			
			socket.on('insertTag', function(tagId, tagName) {
				$(".themes").each(function() {
					if($(this).children().val() == tagId) {
						$(this).removeClass('is-white').addClass('is-link');
					}
				});
				$("#myTagArea").append($('<div class="control"><div class="tags has-addons"><a class="tag is-primary">' 
						+ tagName + '</a><a class="tag is-delete tagDelete"></a><input type="hidden" value="' + tagId + '"></div></div>'));
			});
			
			socket.on('deleteTag', function(tagId, tagName) {
				$(".themes").each(function() {
					if($(this).children().val() == tagId) {
						$(this).removeClass('is-link').addClass('is-white');
					}
				});
				$("#myTagArea .tags.has-addons").each(function() {
					if($(this).children().last().val() == tagId) {
						$(this).parent().remove();
					}
				});
			});
			
			socket.on('insertSchedule', function(schId, dayNumber, schList) {
				updateSchList(dayNumber, schList);
				for(var key in schList) {
					var sch = schList[key];
					
					//가계부는 새로 insert된 일정만 금액이 있을경우에 가계부 리스트에 추가
					if(sch.schId == schId && sch.trvCost != null) {
    					insertNewCost(sch.trvCost);
					}
				}
			});
			
			socket.on('deleteSchedule', function(costId, dayNumber, schList) {
				updateSchList(dayNumber, schList);
				if(costId != undefined) {
					deleteCost(costId);
				}
			});
			
			socket.on('updateSchedule', function(originDayNumber, originSchList, originCostList, changeDayNumber,
					changeSchList, changeCostList) {
				updateSchList(originDayNumber, originSchList);
				updateCostList(originDayNumber, originCostList);
				
				if(changeDayNumber != undefined) {
					updateSchList(changeDayNumber, changeSchList);
					updateCostList(changeDayNumber, changeCostList);
				}
			});
			
			socket.on('reorderSchListInADay', function(dayNumber, schList) {
				//reorderSchListInADay(dayNumber, schList);
				updateSchList(dayNumber, schList);
			});
			
			socket.on('reorderSchListBetweenDays', function(originDayNumber, originSchList, changeDayNumber, changeSchList, costId) {
				updateSchList(originDayNumber, originSchList);
				updateSchList(changeDayNumber, changeSchList);
				
				if(costId != undefined) {
					var costList = $("#day" + changeDayNumber + "CostList"); 
					costList.append($("#cost_" + costId));
				}
			});
			
			socket.on('addGallaryImage', function(dayNumber, changeName, fileLevel, fileId) {
				addGallaryImage(dayNumber, changeName, fileLevel, fileId);
			});
			
			socket.on('changeMainImage', function(fileId) {
				$(".mainImageIcon").hide();
				$(".changeMainImageBtn").show();
				$("input[name=fileId]").each(function() {
					if($(this).val() == fileId) {
						$(this).parent().hide();
						$(this).parent().prev().show();
					}
				});
			});
			
			socket.on('deleteGallaryImage', function(fileId) {
				$("input[name=fileId]").each(function() {
					if($(this).val() == fileId) {
						$(this).parent().parent().parent().remove();
					}
				});
			});
			
			socket.on('changeWeather', function(dayNumber, dayWeather) {
				$("#day" + dayNumber + "Header").find(".weatherArea").find(".weatherBtn").each(function() {
					if($(this).attr("id") == dayWeather) {
						$(this).removeClass('is-outlined');
						$(this).parent().siblings().children().addClass('is-outlined');
						var span = $(this).parent().siblings().eq(0);
						if(dayWeather == "SUN") {
							span.text('맑음');
						}else if(dayWeather == "CLOUD") {
							span.text('흐림');
						}else if(dayWeather == "RAIN") {
							span.text('비');
						}else if(dayWeather == "SNOW") {
							span.text('눈');
						}else if(dayWeather == "LIGHTNING") {
							span.text('번개');
						}
						return;
					}
				});
				
				
			});
			
			socket.on('insertCompany', function(memberId, memberInfo) {
				var compTr = $(".compTr").eq(0).clone(true);
				compTr.children().eq(1).text(memberInfo);
				compTr.find("input[name=memberId]").val(memberId);
				compTr.show();
				$("#compTable").children().append(compTr);
			});
			
			socket.on('deleteCompany', function(memberId) {
				$(".compTr").each(function() {
					var compTr = $(this);
					if($(this).children().eq(0).children("input[name=memberId]").val() == memberId) {
						compTr.remove();
					}
				});
			});
			
			socket.on('updateMemo', function(dayId, memo) {
				$(".day" + dayId + "Memo").each(function() {
					$(this).val(memo);
				});
			});
			
			socket.on('insertCost', function(trvCost) {
				insertNewCost(trvCost);
			});
			
			socket.on('updateCost', function(trvCost) {
				updateCost(trvCost);
			});
			
			socket.on('deleteCost', function(costId, schId) {
				deleteCost(costId);
				if(schId != 0) {
					$(".sch" + schId + "Block").find(".costType").remove();
					$(".sch" + schId + "Block").find(".costAmount").remove();
					$(".sch" + schId + "Block").find(".costCurrency").remove();
				}
			});
			
			socket.on('updateBudget', function(budget) {
				$("#budgetWon").val(budget);
				formatCurrency($("#budgetWon"), "budgetWon", "blur");
				getLocalBudget(budget);
			});
			
			socket.on('completeTravel', function() {
				alert("일정이 작성완료처리 됩니다.");
				location.href="showMyTravel.trv";
			});
		}
	</script>
	
	<div>
		<div id="scheduleEditor">
			<jsp:include page="scheduleEditor.jsp" />
		</div>
		<div id="detailEditor" style="display:none">
			<jsp:include page="detailEditor.jsp" />
		</div>
		<div id="allSchedule" style="display:none;">
			<jsp:include page="allSchedule.jsp" />
		</div>
		<div id="costEditor" style="display:none">
			<jsp:include page="costEditor.jsp" />
		</div>
	</div>
	
	<jsp:include page="travelInfoModal.jsp" />
	
	<script>
		$(function() {
			$(".editorMenu").tab();
		});

		$("#inviteBtn").click(function() {
			$("#inviteDropdown").toggle();
		});
		$(".closeBtn").click(function() {
			$("#inviteDropdown").hide();
		});

		//dayMemo
		$(".dayMemo").change(function() {
			var memo = $(this).val();
			var dayId = $(this).prev().val();
			$.ajax({
				url : "updateDayMemo.trv",
				type : "post",
				data : {dayMemo : memo, dayId : dayId},
				success : function(data) {
					console.log(data);
					console.log($(".day" + dayId + "Memo"));
					$(".day" + dayId + "Memo").each(function() {
						$(this).val(memo);
					});
					
					socket.emit('updateMemo', {
						dayId:dayId,
						memo:memo,
						room:"${ trv.trvId }"
					});
				},
				error : function(data) {
					alert("memo 서버전송 실패");
				}
			});
		});

		//동행검색
		$("#searchComp").change(function() {
			var input = $(this).val();
			$.ajax({
				url : "searchCompany.trv",
				type : "POST",
				data : {
					email : input
				},
				success : function(data) {

					if (data.member != undefined) {
						$("#compSearchMemberId").val(
								data.member.memberId);
						$("#compSearchResult").text(
								data.member.email + " ("
										+ data.member.userName + ")");
						$("#addCompBtn").show();
					} else {
						$("#compSearchMemberId").val(0);
						$("#compSearchResult").text(
								"일치하는 회원 정보를 찾을 수 없습니다.");
						$("#addCompBtn").hide();
					}
				},
				error : function(err) {
					alert("err");
				}
			});
		});

		//동행추가
		$("#addCompBtn").click(function() {
			var memberInfo = $("#compSearchResult").text();
			var memberId = $("#compSearchMemberId").val();
			var compTr = $(".compTr").eq(0).clone(true);
			var exist = false;
			$(".compTr").each(function() {
				if (memberId == $(this).find("input[name=memberId]").val()) {
					alert("이미 동행추가된 멤버입니다.");
					exist = true;
					return;
				}
			});
			if (!exist) {
				$.ajax({
					url : "insertCompany.trv",
					type : "POST",
					data : {memberId : memberId, trvId : "${ trv.trvId }"},
					success : function(data) {
						compTr.children().eq(1).text(memberInfo);
						compTr.find("input[name=memberId]").val(memberId);
						compTr.show();
						$("#compTable").children().append(compTr);
						
						socket.emit('insertCompany', {
							memberId:memberId,
							memberInfo:memberInfo,
							room:"${ trv.trvId }"
						});
					},
					error : function(err) {
						alert("err");
					}
				});
			}
		});

		//동행삭제
		$(".compDeleteBtn").click(function() {
			var memberId = $(this).parent().prev().prev().find("input[name=memberId]").val();
			var answer = window.confirm("해당 멤버를 동행 목록에서 삭제하시겠습니까? '확인' 선택시 이 멤버와는 더이상 일정 공유가 불가합니다.");
			var compTr = $(this).parent().parent();
			if (answer) {
				$.ajax({
					url : "deleteCompany.trv",
					type : "POST",
					data : {memberId : memberId, trvId : "${ trv.trvId }"},
					success : function(data) {
						compTr.remove();
						alert("삭제되었습니다.");
						
						socket.emit('deleteCompany', {
							memberId:memberId,
							room:"${ trv.trvId }"
						});
					},
					error : function(err) {
						alert("deleteCompany 서버전송 실패");
					}
				});
			}
		});

		$(".editorMenu li").click(function() {
			$(this).addClass('is-active');
			$(this).siblings().removeClass('is-active');
			var menu = $(this).children().children().text();
			switch (menu) {
			case '일정작성':
				$("#scheduleEditor").show();
				$("#scheduleEditor").siblings().hide();
				loadMap(map);
				break;
			case '상세글작성':
				$("#detailEditor").show();
				$("#detailEditor").siblings().hide();
				break;
			case '일정전체보기':
				$("#allSchedule").show();
				$("#allSchedule").siblings().hide();
				loadMapWide(mapWide);
				break;
			case '가계부':
				$("#costEditor").show();
				$("#costEditor").siblings().hide();
				break;
			}
		});

		function goToMyTravel() {
			location.href = "showMyTravel.trv";
		}
		function completeTravel() {
			if ("${ trv.trvRef }" == 0) {
				var answer = window
						.confirm("[작성완료 안내] \n1. 작성완료 처리시 사이트에 이 일정의 1/3이 미리보기로 공개되며"
								+ "\n2. 다른 회원이 이 일정을 구입하여 이를 바탕으로 새일정 작성이 가능해집니다."
								+ "\n3. 한 일정당 총 구매된 금액이 최소 금액을 초과하게 되면 수익금이 작성자에게 지급됩니다."
								+ "\n4. 또한, 추후 이 일정은 수정 및 삭제가 불가합니다."
								+ "\n5. 작성완료 처리시 일정 공유에 대한 포인트가 지급됩니다. \n공개하시겠습니까?");
				if (answer) {
					location.href = "completeTravel.trv?trvId=${ trv.trvId }&memberId=${ sessionScope.loginUser.memberId }";
					
					socket.emit('completeTravel', {
						room:"${ trv.trvId }"
					});
				}
			} else {
				alert("다른 일정을 오버라이딩 한 일정은 개인소장만 가능하며, 사이트 공개가 불가합니다.");
			}
		}
		function deleteTravel() {
			var answer = window.confirm("정말로 삭제하시겠습니까? 해당 여행의 일정이 모두 삭제됩니다.");
			if (answer) {
				location.href = "deleteTravel.trv?trvId=${ trv.trvId }";
			}
		}
	</script>
	<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyC7fLkDFvRtLNooR612ov12h_gwdsqDI6Q&libraries=places&callback=initMap"
    async defer></script>
	<script src="resources/js/travel/map-icons.js"></script>
	<!-- <script src="resources/js/travel/travel.js"></script> -->
	<script>
		
		var map;
		var mapWide;
		var service;
		var infowindow;
		var searchBox;
		var labels = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
		var labelIndex = 0;
		var icons = {
			basic:{
				icon:{
					path:mapIcons.shapes.MAP_PIN,
					fillColor: '#8B44F0',
					fillOpacity:1,
					scale:0.8,
					strokeColor:'',
					strokeWeight:0
				},
				map_icon_label : '<span class="map-icon map-icon-postal-code"></span>'
			},
			restaurant:{
				icon:{
					path:mapIcons.shapes.MAP_PIN,
					fillColor: '#F1BF1E',
					fillOpacity:1,
					scale:0.8,
					strokeColor:'',
					strokeWeight:0
				},
				map_icon_label : '<span class="map-icon map-icon-restaurant"></span>'
			},
			bar:{
				icon:{
					path:mapIcons.shapes.MAP_PIN,
					fillColor: '#DE2C26',
					fillOpacity:1,
					scale:0.8,
					strokeColor:'',
					strokeWeight:0
				},
				map_icon_label : '<span class="map-icon map-icon-night-club"></span>'
			},
			cafe:{
				icon:{
					path:mapIcons.shapes.MAP_PIN,
					fillColor: '#926B25',
					fillOpacity:1,
					scale:0.8,
					strokeColor:'',
					strokeWeight:0
				},
				map_icon_label : '<span class="map-icon map-icon-cafe"></span>'
			},
			museum:{
				icon:{
					path:mapIcons.shapes.MAP_PIN,
					fillColor: '#888888',
					fillOpacity:1,
					scale:0.8,
					strokeColor:'',
					strokeWeight:0
				},
				map_icon_label : '<span class="map-icon map-icon-museum"></span>'
			},
			park:{
				icon:{
					path:mapIcons.shapes.MAP_PIN,
					fillColor: '#0C6916',
					fillOpacity:1,
					scale:0.8,
					strokeColor:'',
					strokeWeight:0
				},
				map_icon_label : '<span class="map-icon map-icon-park"></span>'
			},
			shopping_mall:{
				icon:{
					path:mapIcons.shapes.MAP_PIN,
					fillColor: '#44BCF0',
					fillOpacity:1,
					scale:0.8,
					strokeColor:'',
					strokeWeight:0
				},
				map_icon_label : '<span class="map-icon map-icon-grocery-or-supermarket"></span>'
			},
			hotel:{
				icon:{
					path:mapIcons.shapes.MAP_PIN,
					fillColor: '#60D8D0',
					fillOpacity:1,
					scale:0.8,
					strokeColor:'',
					strokeWeight:0
				},
				map_icon_label : '<span class="map-icon map-icon-lodging"></span>'
			}
			
		};
		var markers = [];
		function initMap() {
			
			var sydney = new google.maps.LatLng(-33.867, 151.195);
			map = new google.maps.Map(document.getElementById('map'), {zoom:13, center:sydney});
			mapWide = new google.maps.Map(document.getElementById('mapWide'), {zoom:15, center:sydney});
			infowindow = new google.maps.InfoWindow();
			service = new google.maps.places.PlacesService(map);
			serviceWide = new google.maps.places.PlacesService(mapWide);
			searchBox = new google.maps.places.SearchBox(document.getElementById('searchInput'));
			map.controls[google.maps.ControlPosition.LEFT_TOP].push(document.getElementById('left-panel'));
			mapWide.controls[google.maps.ControlPosition.RIGHT_TOP].push(document.getElementById('right-panel'));
			
			var cityRequest = { 
				query:"${ trvCityList[0].cityNameEn }",
				fields:['geometry']
			};
			service.findPlaceFromQuery(cityRequest, function(results, status) {
				if(status === google.maps.places.PlacesServiceStatus.OK) {
					map.setCenter(results[0].geometry.location);
				}
			});
			serviceWide.findPlaceFromQuery(cityRequest, function(results, status) {
				if(status === google.maps.places.PlacesServiceStatus.OK) {
					mapWide.setCenter(results[0].geometry.location);
				}
			});
			
			
			map.addListener('click', function(e) {
				if(e.placeId) {
					console.log(e.placeId);
					placeDetailSearch(e.placeId, map);
				}
			});

			map.addListener('bounds_changed', function() {
				searchBox.setBounds(map.getBounds());
			});
			
			searchBox.addListener('places_changed', function() {
				var places = searchBox.getPlaces();
				if(places.length === 0) {
					return;
				}
				markers = [];
				var bounds = new google.maps.LatLngBounds();
				places.forEach(function (p) {
					if(!p.geometry) {
						return;
					}
					
					if(p.geometry.viewport) {
						bounds.union(p.geometry.viewport);
					}else {
						bounds.extend(p.geometry.location);
					}
				});
				
				placeDetailSearch(places[0].place_id, map);
				map.fitBounds(bounds);
			});
			
			loadMap(map);
			
		}
		
		
		function loadMap(map) {
			
			var places = [];
			$("#day1").find("input[name=plcId]").each(function() {
				places.push($(this).val());
			});
			showRoute(places, map);
		}
		
		function loadMapWide(map) {
			
			var places = [];
			$(".dayPanel").each(function() {
				var dayNumber = $(this).attr("id").charAt(3);
				$(this).find("input[name=plcId]").each(function() {
					places.push($(this).val());
				});
			});
			showRoute(places, map);
		}
		
		
		
		var dayPath;
		function showRoute(places, map) {
			
			markers.forEach(function(m) {
				m.setMap(null);
			});
			markers = [];
			if(dayPath != undefined) {
				dayPath.setMap(null);
			}
			if(places.length == 0) {
				return;				
			}
			var bounds = new google.maps.LatLngBounds();
			dayPath = new google.maps.Polyline({
			    strokeColor: '#FB0303',
			    strokeOpacity: 1.0,
			    strokeWeight: 2
			});
			places.forEach(function(p, index) {
				var request = {
					placeId:p,
					fiels:['geometry', 'name']
				}
					
				service.getDetails(request, function(place, status) {
					if(status == google.maps.places.PlacesServiceStatus.OK) {
						
						var m = new google.maps.Marker({
							map:map,
							label: {
								fontSize:'20px',
								text:index + 1 + "",
								color:'#fff'
							},
							animation: google.maps.Animation.DROP,
							title: place.name,
							position: place.geometry.location
						});
						
						markers.push(m);
						dayPath.setMap(map);
						var path = dayPath.getPath();
						path.push(place.geometry.location);
						
						if(place.geometry.viewport) {
							bounds.union(place.geometry.viewport);
						}else { 
							bounds.extend(m.position);
						}
						
						if(index == 0) {
							map.setCenter(m.position);
						}
						
						m.addListener('click', function() {
							placeDetailSearch(place.place_id, map);
						});
					}
				});
				
			});
			
			
			map.fitBounds(bounds, 0);
			var fitBoundsListener = google.maps.event.addListener(map, 'idle', function() {
		    	if (map.getZoom() < 15) map.setZoom(15); 
		    	google.maps.event.removeListener(fitBoundsListener); 
			});
		}
	
		function placeTextSearch(placeName, map, insert) {
			console.log(placeName);
			var request = { 
				query:placeName,
				fields:['place_id', 'name']
			};
			service.findPlaceFromQuery(request, function(results, status) {
				if(status === google.maps.places.PlacesServiceStatus.OK) {
					console.log(results[0].place_id);
					console.log(results[0].name);
					placeDetailSearch(results[0].place_id, map);
					if(insert == "insert") {
						$("#plcId1").val(results[0].place_id);
						
						if(results[0].name == "") {
							$("#plcName1").val(placeName);
						}else {
							$("#plcName1").val(results[0].name);
						}
					}
				}
			});
		}
		
		
		function placeDetailSearch(placeId, map) {
			var request = {
				placeId: placeId,
				fields:['name', 'formatted_address', 'international_phone_number', 'geometry',
					'rating', 'opening_hours', 'photos', 'reviews', 'website']
			};
			
			service.getDetails(request, function(place, status) {
				if(status == google.maps.places.PlacesServiceStatus.OK) {
					
					$("#detail-panel, #detail-panel-wide").show();
					$("#placeId, #placeIdWide").val(placeId);
					$("#placeName, #placeNameWide").text(place.name);
					$("#placeAdd, #placeAddWide").text(place.formatted_address);
					$("#placePhone, #placePhone").text(place.international_phone_number);
					
					if(place.photos != undefined) {
						$("#placePhoto, #placePhotoWide").attr("src", place.photos[0].getUrl());
					}
					if(place.opening_hours != undefined) {
						$("#openHour, #openHourWide").text(place.opening_hours.weekday_text.toString());
					}
					$("#ratingStar, #ratingStarWide").rating("set rating", Math.floor(place.rating));
					$("#placeRating, #palceRatingWide").text(place.rating);
					
					if(place.reviews != undefined) {
						for(var i = 0; i < place.reviews.length; i++) {
							if(i < 5) {
								$('<p><small><em>' + place.reviews[i].text + '(' +  place.reviews[i].relative_time_description 
										+ ') - ' + place.reviews[i].author_name + '</em></small></p>').appendTo($("#placeReview, #placeReviewWide"));
							}
						}
						if(place.reviews.length > 5) {
							$('<p><small><em>.....</em></small></p>').appendTo($("#placeReview, #placeReviewWide"));
						}
					}
					
					var m = new google.maps.Marker({
						map:map,
						title: place.name,
						position: place.geometry.location
					});
					
					markers.push(m);
					var bounds = new google.maps.LatLngBounds();
					if(place.geometry.viewport) {
						bounds.union(place.geometry.viewport);
					}else {
						bounds.extend(place.geometry.location);
					}
					map.fitBounds(bounds);
					
					
					if(map == mapWide) {
						$("#detail-panel").hide();
					}else {
						$("#detail-panel-wide").hide();
					}
					
					$("#closePlaceDetail").click(function() {
						$("#detail-panel").hide();
						$("#searchInput").val('');
						m.setMap(null);
					});
					$("#closePlaceDetailWide").click(function() {
						$("#detail-panel-wide").hide();
						m.setMap(null);
					});
					
				}
			});
		}
	
		var typeMarkers = [];
		function placeTypeSearch(placeType, map) {
			
			var getNextPage = null;
			var moreBtn = document.getElementById('more');
			moreBtn.onclick = function() {
				moreBtn.disabled = true;
				if(getNextPage) getNextPage();
			};
			
			typeMarkers.forEach(function(marker) {
				marker.setMap(null);
			});
			typeMarkers = [];
			var request = {
					location: map.getCenter(),
					radius: '1000',
					type: [placeType]
			};
			service.textSearch(request, function(results, status, pagination) {
				var bounds = new google.maps.LatLngBounds();
				var placeList = document.getElementById('placeList');
				if (status === google.maps.places.PlacesServiceStatus.OK) {
					for (var i = 0; i < results.length; i++) {
						var li = document.createElement('li');
						li.innerHTML += '<input type="hidden" name="placeId" value="' 
										+ results[i].place_id + '" />' + '<p><strong>' 
										+ results[i].name + '<small style="color:purple"> review:' 
										+ results[i].rating + '/5.0 </small></strong></p><p class="help">' 
										+ results[i].formatted_address  + '</p>'
						placeList.appendChild(li);
						bounds.extend(results[i].geometry.location);
						addMarker({
							location:results[i].geometry.location,
							icon:icons[placeType].icon,
							map_icon_label:icons[placeType].map_icon_label,
							place_id:results[i].place_id,
							info: '<h5 class="title is-5">' + results[i].name + "'</h5>" 
									+ results[i].formatted_address
						});
					}
					map.fitBounds(bounds);
					moreBtn.disabled = !pagination.hasNextPage;
					getNextPage = pagination.hasNextPage && function() {
						pagination.nextPage();
					}
					map.setCenter(results[0].geometry.location);
				}else return;
				
				$("#placeList").children("li").click(function() {
					var placeId = $(this).children("input[name=placeId]").val();
					console.log(placeId);
					placeDetailSearch(placeId, map);
				});
				
				$("#typeSearchDelete").click(function() {
					typeMarkers.forEach(function(marker) {
						marker.setMap(null);
					});
					typeMarkers = [];
					$("#placeList").empty();
				});
				
			});
		}
	
		function addMarker(props) {
			var marker = new mapIcons.Marker({
				position: props.location,
				//label: labels[labelIndex++ % labels.length],
				icon:props.icon,
				map_icon_label:props.map_icon_label,
				map: map
			});
			
			typeMarkers.push(marker);
			if(props.info) {
				var infoWindow = new google.maps.InfoWindow({
					content:props.info
				});
				marker.addListener('click', function() {
					infoWindow.open(map, marker);
				});
			}
			
			marker.addListener('click', function() {
				
				placeDetailSearch(props.place_id, map);
			});
			
			
		}
	
	</script>
	
	
	
	
</body>
</html>