<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
	.pagingBtn{
		width:30px;
		height:22px;
		background:white;
		color:purple;
		border:1px solid purple;
		border-radius:5px;
	}
	.pagingBtn:hover{
		background:purple;
		color:white;
	}
	#aPointTB *{
		text-align:center;
	}
	tbody *:hover{
		background:#ededff;
		color:#8484ff;
		font-weight:bold;
	}
</style>
</head>
<body>
	<jsp:include page="../../common/adminMainNav.jsp"/>
	<div class="columns is-mobile">
		<div class="column">
			<section class="section" id="headerSection" style="margin-bottom:-60px;">
				<jsp:include page="aPointNav.jsp"/>				
			</section>
			<section class="section">
				<div class="container" style="width:90%;height:100%;">
					<div style="width:100%;font-size:25px;color:#209cee;">환불 내역</div>
			         <div style="width:100%;height:100%;">
			         	<div>
			         		<div class="field has-addons" style="float:right;">
								<p class="control">
									<input type="checkbox" style="display:inline-block;float:left;" id="searchNameCheck" name="searchNameCheck">
									<p style="width:100px;display:inline-block;"><label for="searchNameCheck">이름 검색하기</label></p>
									<input class="input" type="text" placeholder="회원ID를 검색하세요" style="width:150px;height:20px;display:none" id="nameArea">
								</p>
								<div class="select is-small is-primary" style="display:inline-block;float:right;margin-left:2%;">
						            <select name="refundSelect" id="refundSelect"style="height:20px;">
						              <option value="0">--환불승인상태--</option>
						              <option value="10">대기중</option>
						              <option value="20">승인</option>
						              <option value="30">거절</option>
						            </select>
						        </div>
								<p class="control" id="search" style="margin-left:1%;display:inline-block;float:right;">
									<a class="button is-primary" style="width:60px;height:20px;">
										<i class='fas fa-search' style='font-size:15px'></i>검색
									</a>
								</p>
							</div>
						</div>
			         	<div style="width:100%;height:25px;"></div>
			         </div>
			         <div style="width:100%;height:100%;" id="aPointArea">
						<table id="aPointTB" class="table is-narrow" align="center"style="width:100%;height:100%;" >
							<thead>
								<tr style="background:#ccccff;">
									<th width="1%"> No. </th>
									<th> 이름 </th>
									<th> 이메일 </th>
									<th> 구매일 </th>
									<th> 글 제목 </th>
									<th> 포인트 </th>
									<th> 환불 사유 </th>
									<th> 환불 승인 </th>
									<th> 승인 상태 </th>
								</tr>
							</thead>
							<tbody id="aRefundTBody" >
								
							</tbody>
						</table>
			         </div>
					<div align="center" class="pagingBtnArea" style="margin-top:3%;">
					  		
				</div>
					
				</div>
			</section>
			<section class="section" id="modal">
				<div class="modal" id="myModal">
					<div class="modal-background"></div>
					<div class="modal-card">
						<header class="modal-card-head">
							<p class="modal-card-title"style="line-height:180%;">환불 상세 내역<br>
								<textarea cols="75" rows="6" style="font-size:13px;resize:none;line-height:150%;" id="modalHeadContent"></textarea>
							</p>
							<button class="delete" id="del"></button>
						</header>
						<section class="modal-card-body">
							<textarea cols="85" rows="15" style="resize:none;" readonly id="modalBodyContent"></textarea>
						</section>
						<footer class="modal-card-foot">
							<div style="margin-left:auto;margin-right:auto;">
								<input type="hidden" id="refIdArea">
								<input type="hidden" id="bidArea">
								<input type="hidden" id="midArea">
								<a class="button is-success modalYes" style="border-radius:5px; height:25px;"> 승인 </a>
								<a class="button is-danger modalNo" style="border-radius:5px; height:25px;"> 거절 </a>
							</div>
						</footer>
					</div>
				</div>
			</section>
		</div>
	</div>
	<script type="text/javascript">
		$(function() {
			$(".apointRef").parent().addClass('is-active');
			$(".apointRef").children().css({"color":"#209cee"});
			$('.modal-background, .modal-close').click(function() {
				$(this).parent().removeClass('is-active');
			});
			
			$("#del").click(function(){
				$(this).parent().parent().parent().removeClass('is-active');
			});
			
			var memberId = ${sessionScope.loginUser.memberId};
			var currentPage = 1;
			total(currentPage, memberId);
			//체크 상태에 따라 인풋태그 보여주기
			$("#searchNameCheck").change(function(){
				if($("#searchNameCheck").is(":checked")){
					$("#nameArea").css({"display":"inline-block"});
				}else{
					$("#nameArea").css({"display":"none"});
				}
			});
			
			//검색 버튼 눌렀을 때
			$("body").on("click", "#search", function(){
				var memberId = ${sessionScope.loginUser.memberId};//검색 버튼 눌렀을 때
				searchFunc(currentPage, memberId);//검색 에이작스 함수 호출
			});
		});
		function total(currentPage, memberId){
			var condition = 99;
			$.ajax({
				url:"adRefund.po",
				type:"post",
				data:{memberId:memberId,currentPage:currentPage, condition:condition},
				success:function(data){
					console.log('success');
					console.log(data);
					makeRefundTB(data.adRefundList, data.adRefundPi, condition);
				},
				error:function(data){
					console.log('error');
				}
			});
		};
		function makeRefundTB(adRefundList, adRefundPi, condition){
			console.log(condition);
			$("#aRefundTBody").empty();
			var len = adRefundList.length;
			
			for(var i=0 ; i<len ; i++){
				var list = adRefundList[i];
				var pi = adRefundPi;

				var $listTr = $("<tr>");
				
				var $noTd = $("<td class='modalOpen'>").text(i+1);
				var $refId = $("<input type='hidden'>").val(list.refundId);
				$noTd.append($refId);
				var $boardId, $useTypeId;
				var $memberId = $("<input type='hidden'>").val(list.memberId);
				
				var $userNameTd = $("<td class='modalOpen'>").text(list.userName);
				var $emailTd = $("<td class='modalOpen'>").text(list.email);
				
				var date = new Date(list.useDate);
				date = getFormatDate(date);
				var $useDateTd = $("<td class='modalOpen'>").text(date);
				
				var $titleTd;
				
				if(list.useType == 10){
					$titleTd = $("<td class='modalOpen'>").text(list.trvTitle);
					$boardId = $("<input type='hidden'>").val(list.trvId);
					$useTypeId = $("<input type='hidden'>").val(list.useType);
				}else if(list.useType == 20){
					$titleTd = $("<td class='modalOpen'>").text(list.planTitle);
					$boardId = $("<input type='hidden'>").val(list.requestId);
					$useTypeId = $("<input type='hidden'>").val(list.useType);
				}
				$noTd.append($boardId);
				$noTd.append($memberId);
				$noTd.append($useTypeId);
				
				
				var usePoint = list.usePoint;
				usePoint = comma(usePoint);
				var $usePointTd = $("<td class='modalOpen'>").text(usePoint+"P");
				
				var refundReason = list.refundReason;
				refundReason = refundReason.substring(0,6);
				var $refundReasonTd = $("<td class='modalOpen'>").text(refundReason+"...");
				
				var $processTd = $("<td>");
				
				var $processBtnYes, $processBtnNo;
				
				var refundStatus = list.refundStatus;
				
				console.log(refundStatus);
				if(refundStatus != 10){
					$processBtnYes = $('<button id="toApprove" disabled="true" class="button is-success is-outlined yes" style="width:70px;height:20px;line-height:50%;"> 승인 </button>');
					$processBtnNo = $('<button id="toRefuse" disabled="true" class="button is-danger is-outlined no" style="width:70px;height:20px;line-height:50%;"> 거절 </button>');
				}else{
					$processBtnYes = $('<button id="toApprove" class="button is-success is-outlined yes" style="width:70px;height:20px;line-height:50%;"> 승인 </button>');
					$processBtnNo = $('<button id="toRefuse" class="button is-danger is-outlined no" style="width:70px;height:20px;line-height:50%;"> 거절 </button>');
				}
				
				$processTd.append($processBtnYes);
				$processTd.append($processBtnNo);
				
				var $statusTd = $("<td>");
				var $statusIn;
				if(refundStatus==10){//대기중
					$statusIn = $('<a class="button is-primary" style="width:70px;height:20px;"> 대기중 </a>');
				}else if(refundStatus == 20){//승인
					$statusIn = $('<a class="button is-success" style="width:70px;height:20px;"> 승인 </a>');		
				}else if(refundStatus == 30){//거절
					$statusIn = $('<a class="button is-danger" style="width:70px;height:20px;"> 거절 </a>');
				}
				
				$statusTd.append($statusIn);
				
				$listTr.append($noTd);
				$listTr.append($userNameTd);
				$listTr.append($emailTd);
				$listTr.append($useDateTd);
				$listTr.append($titleTd);
				$listTr.append($usePointTd);
				$listTr.append($refundReasonTd);
				$listTr.append($processTd);
				$listTr.append($statusTd);
				
				$("#aRefundTBody").append($listTr);
				paging(pi, condition);
			}
			$(".modalOpen").click(function(){
				$('#myModal').toggleClass('is-active');
				var title, bid, refId, mid;
				refId = $(this).parent().children().eq(0).children().eq(0).val();
				bid = $(this).parent().children().eq(0).children().eq(1).val();
				mid = $(this).parent().children().eq(0).children().eq(2).val();
				useTypeId = $(this).parent().children().eq(0).children().eq(3).val();
				
				if(list.useType == 10){
					title = list.trvTitle;
					bid = list.trvId;
				}else if(list.useType == 20){
					title = list.planTitle;
					bid = list.requestId;
				}
				$("#modalHeadContent").text('이름 : '
						+list.userName+'\n이메일 : '
						+list.email+'\n구매일 :'
						+date+'\n구매 포인트 : '
						+list.usePoint+'\n구매한 게시글 : '
						+title);
				$("#modalBodyContent").text(list.refundReason);
				$("#refIdArea").val(refId);
				$("#bidArea").val(bid);
				$("#midArea").val(mid);
				
			});
		};
		$("body").on("click", "#toApprove", function(){
			var refId = $(this).parent().parent().children().eq(0).children().eq(0).val();
			var bid = $(this).parent().parent().children().eq(0).children().eq(1).val();
			var cond = 10;
			console.log(refId);
			approve(refId, bid, cond);
		});
		$("body").on("click", "#toRefuse", function(){
			var refId = $(this).parent().parent().children().eq(0).children().eq(0).val();
			var bid = $(this).parent().parent().children().eq(0).children().eq(1).val();
			var cond = 20;
			refuse(refId, bid, cond);
		});
		$("body").on("click", ".modalYes", function(){
			var refId = $(this).parent().children().eq(0).val();
			var bid = $(this).parent().children().eq(1).val();
			var cond = 10;
			$('#myModal').removeClass('is-active');
			approve(refId, bid, cond);
		});
		$("body").on("click", ".modalNo", function(){
			var refId = $(this).parent().children().eq(0).val();
			var bid = $(this).parent().children().eq(1).val();
			var cond = 20;
			$('#myModal').removeClass('is-active');
			refuse(refId, bid, cond);
		});
		//승인
		function approve(refId, bid, cond){
			location.href="updateAdRefund.po?refId="+refId+"&bid="+bid+"&cond="+cond;
		}
		//거절
		function refuse(refId, bid, cond){
			location.href="updateAdRefund.po?refId="+refId+"&bid="+bid+"&cond="+cond;
		} 
		function paging(pi, condition){
			//console.log(pi);
			var memberId = ${sessionScope.loginUser.memberId};
			var $page = $(".pagingBtnArea");
			
			var currentPage = pi.currentPage;
			var limit = pi.limit;
			var maxPage = pi.maxPage;
			var startPage = pi.startPage;
			var endPage = pi.endPage;
			
			$page.empty();
			
			$page.append($("<button>").attr("class", "pagingBtn").text(" << ").css({"cursor":"pointer"}).click(function(){
				if(condition == 99){
					total(1, memberId);
				}else{
					searchFunc(1, memberId);
				}
			}));
			
			if(currentPage <= 1){
				$page.append($("<button>").attr("class", "pagingBtn").attr("disabled",true).text(" < ").css({"cursor":"pointer"}));
			}else{
				$page.append($("<button>").attr("class", "pagingBtn").text("<").click(function(){
					if(condition == 99){
						total(currentPage-1, memberId);
					}else{
						searchFunc(currentPage-1, memberId);
					}
              }));
			}
			for(var p=startPage ; p<=endPage ; p++){
				if(p == currentPage){
					$page.append($("<button>").attr("class", "pagingBtn").text(p).attr("disabled",true).css({"cursor":"pointer"}));
				}else{ 
					$page.append($("<button>").attr("class", "pagingBtn").text(p).css({"cursor":"pointer"}).click(function(){
						if(condition == 99){
							total($(this).text(),memberId);
						}else{
							searchFunc($(this).text(),memberId);
						}
					}));
				}
			}
			if(currentPage >= maxPage){ 
				$page.append($("<button>").attr("class", "pagingBtn").attr("disabled",true).text(" > ").css({"cursor":"pointer"}));         
            }else {
            	$page.append($("<button>").attr("class", "pagingBtn").attr("disabled",true).text(" > ").css({"cursor":"pointer"}).click(function(){
            		if(condition == 99){
            			total(currentPage + 1, memberId);
					}else{
						searchFunc(currentPage + 1, memberId);
					}
            	}));
            } 
			$page.append($("<button>").attr("class", "pagingBtn").text(" >> ").css({"cursor":"pointer"}).click(function(){
				if(condition == 99){
					total(maxPage, memberId);
				}else{
					searchFunc(maxPage, memberId);
				}
            }));
		}
		function getFormatDate(date){ 
			//console.log(date);
			//console.log(typeof(date));
			var year = date.getFullYear()+'';	//yyyy 
			year = year.substring( 2, 4 );
			var month = (1 + date.getMonth());	//M 
			month = month >= 10 ? month : '0' + month;	//month 두자리로 저장 
			var day = date.getDate();	//d
			day = day >= 10 ? day : '0' + day;	//day 두자리로 저장
			var hour = date.getHours();
			hour = hour >=10 ? hour : '0' + hour;
			var minu = date.getMinutes();
			minu = minu >=10 ? minu : '0' + minu;
			return year + '/' + month + '/' + day + '	' + hour + ':' + minu; 
		};
		function comma(num){
		    var len, point, str; 
		       
		    num = num + ""; 
		    point = num.length % 3 ;
		    len = num.length; 
		   
		    str = num.substring(0, point); 
		    while (point < len) { 
		        if (str != "") str += ","; 
		        str += num.substring(point, point + 3); 
		        point += 3; 
		    } 
		    return str;
		};
		//검색 에이작스 함수
		function searchFunc(currentPage, memberId){
			$("#refundSelect").change(function(){
				var refundSta = $(this).children('option:selected').val();
				console.log(refundSta);
				
				if(refundSta != 0){
					
				}
			});
			var userName = $("#nameArea").val();
			//console.log(userName);
			
			var condition = 99;
			
			var status = 99;//정상
			
			if($("#searchNameCheck").is(":checked")){
				condition = 10;
				if(userName ==""){
					status = 10;//비정상
				}
			}
			
			if(condition == 99){
				status = 10;
			}
			
			if(startMili <= endMili && status != 10){
				$.ajax({
					url:"seacrchAdPay.po",
					type:"post",
					data:{userName:userName, startDate:startDate, endDate:endDate, condition:condition, currentPage:currentPage},
					success:function(data){
						console.log('success');	
						makePayTB(data.adPayList, data.adPayPi, condition);
					},
					error:function(data){
						console.log('error');
					}
				});
			}else if(startMili > endMili){
				$('#myModal').removeClass('is-active');
				$('#modalHeader2').text('검색 시작날짜와 종료날짜의 폼은 맞춰주세요');
				$("#myModal2").toggleClass('is-active');
				$("#okay").click(function(){
					$('#myModal2').removeClass('is-active');
				});
			}else if(status ==10){
				$('#myModal').removeClass('is-active');
				$('#modalHeader2').text('검색 조건을 입력해주세요');
				$("#myModal2").toggleClass('is-active');
				$("#okay").click(function(){
					$('#myModal2').removeClass('is-active');
				});
			}
		};
	</script>
</body>
</html>