<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>PDF DOWNLOAD</title>
<style>


#loader {
	display: none;
	z-index: 999;
	width: 100%;
	height: 100%;
	position: fixed;
	top: 0;
	left: 0;
	background: #000;
	opacity: .5;
}

#loader span {
	position: absolute;
	top: 50%;
	left: 50%;
	transform: translate(-50%, -50%);
	display: inline-block;
	color: #fff;
	font-weight: bold;
}




</style>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bluebird/3.7.2/bluebird.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/1.5.3/jspdf.min.js"></script>
<script src="https://unpkg.com/html2canvas@1.0.0-rc.5/dist/html2canvas.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.9.2/html2pdf.bundle.min.js"></script>
</head>

<body>
	<div id="loader"><span>잠시만 기다려주세요...</span></div>
	<button type="button" onclick="createPdf()">이미지만 PDF 만들기</button>
	<div class="wrap">
		<div class="pdfArea">
			<img src="${pageContext.request.contextPath }/resources/image/audi01.png">
			<img src="${pageContext.request.contextPath }/resources/image/audi02.png">
			<img src="${pageContext.request.contextPath }/resources/image/audi03.png">
			<img src="${pageContext.request.contextPath }/resources/image/audi04.png">
			<img src="${pageContext.request.contextPath }/resources/image/bmw.png">
			<img src="${pageContext.request.contextPath }/resources/image/bmw01.jpg">
			<img src="${pageContext.request.contextPath }/resources/image/bmw02.jpg">
			<img src="${pageContext.request.contextPath }/resources/image/bmw03.jpg">
		</div>
	</div>
	
	

	<form action="" method="post" id="mainForm">
		<p>userId : <input type="text" id="userId" value="a001" name="userId"/></p>
		<p>password : <input type="text" id="password" value="1234" name="password"/></p>
	</form>
	<button id="download">PDF다운로드</button> 
	
	<!--캡처영역-->
    <div id="main_capture">
        <h3>A B C D E F G</h3>
    </div>
    <button id="pick">캡쳐 Download</button> <!-- 영역만 캡쳐하기 --> <!-- 이것도 안나옴  -->
    
    <!-- 현재 마지막 이미지가 짤림(페이지에 걸쳐서나옴)-->
	<button id="captureBtn">전체화면 캡쳐 & pdf 다운로드</button>
</body>
<script type="text/javascript">


var renderedImg = new Array;

var contWidth = 200, // 너비(mm) (a4에 맞춤)
	padding = 5; //상하좌우 여백(mm)


	
//이미지를 pdf로 만들기
function createPdf() { 
	document.getElementById("loader").style.display = "block"; //로딩 시작

	var images = document.querySelectorAll(".pdfArea > img"),
			deferreds = [],
			doc = new jsPDF("p", "mm", "a4"),
			imagesLength = images.length;

	for (var i = 0; i < imagesLength; i++) { // 이미지 개수만큼 이미지 생성
		var deferred = $.Deferred();
		deferreds.push(deferred.promise());
		generateCanvas(i, doc, deferred, images[i]);
	}

	$.when.apply($, deferreds).then(function () { // 이미지 렌더링이 끝난 후
		var sorted = renderedImg.sort(function(a,b){return a.num < b.num ? -1 : 1;}), // 순서대로 정렬
				curHeight = padding, //위 여백 (이미지가 들어가기 시작할 y축)
				sortedLength = sorted.length;
	
		for (var i = 0; i < sortedLength; i++) {
			var sortedHeight = sorted[i].height, //이미지 높이
					sortedImage = sorted[i].image; //이미지

			if( curHeight + sortedHeight > 297 - padding * 2 ){ // a4 높이에 맞게 남은 공간이 이미지높이보다 작을 경우 페이지 추가
				doc.addPage(); // 페이지를 추가함
				curHeight = padding; // 이미지가 들어갈 y축을 초기 여백값으로 초기화
				doc.addImage(sortedImage, 'jpeg', padding , curHeight, contWidth, sortedHeight); //이미지 넣기
				curHeight += sortedHeight; // y축 = 여백 + 새로 들어간 이미지 높이
			} else { // 페이지에 남은 공간보다 이미지가 작으면 페이지 추가하지 않음
				doc.addImage(sortedImage, 'jpeg', padding , curHeight, contWidth, sortedHeight); //이미지 넣기
				curHeight += sortedHeight; // y축 = 기존y축 + 새로들어간 이미지 높이
			}
		}
		doc.save('pdf_test.pdf'); //pdf 저장

		document.getElementById("loader").style.display = "none"; //로딩 끝
		curHeight = padding; //y축 초기화
		renderedImg = new Array; //이미지 배열 초기화
	});
}

	

function generateCanvas(i, doc, deferred, curImage){ //페이지를 이미지로 만들기
	var pdfWidth = $(curImage).outerWidth() * 0.2645, //px -> mm로 변환
			pdfHeight = $(curImage).outerHeight() * 0.2645,
			heightCalc = contWidth * pdfHeight / pdfWidth; 
	//비율에 맞게 높이 조절
	html2canvas(curImage).then(
		function (canvas) {
			var img = canvas.toDataURL('image/jpeg', 1.0); //이미지 형식 지정
			renderedImg.push({num:i, image:img, height:heightCalc}); //renderedImg 배열에 이미지 데이터 저장(뒤죽박죽 방지)     
			deferred.resolve(); //결과 보내기
		}
	);
}

$(function(){
    $("#pick").on("click", function(){
    // 캡처 라이브러리를 통해 canvas 오브젝트 받고 이미지 파일로 리턴함
    html2canvas(document.querySelector("#main_capture")).then(canvas => {
                saveAs(canvas.toDataURL('image/jpg'),"lime.jpg"); //다운로드 되는 이미지 파일 이름 지정
                });
    });
    function saveAs(uri, filename) {
        // 캡처된 파일을 이미지 파일로 내보냄
        var link = document.createElement('a');
        if (typeof link.download === 'string') {
            link.href = uri;
            link.download = filename;
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        } else {
            window.open(uri);
        }
    }
    
 
});

$(document).ready(function(){
	
    $("#captureBtn").click(function(){
    	setTimeout(function() {
    		captureAndDownloadPDF();
    		}, 100);
    });
});

function captureAndDownloadPDF() {

	html2canvas(document.body, {
        scrollX: 0,
        scrollY: 0,
        scale: 2 // 적절한 스케일 조정
    }).then(function (canvas) {
        var imgData = canvas.toDataURL('image/png');
        var doc = new jsPDF('p', 'mm', 'a4');

        var imgWidth = 210; // A4 크기
        var pageHeight = imgWidth * 1.414; // A4 비율
        var imgHeight = canvas.height * imgWidth / canvas.width;
        var heightLeft = imgHeight;
        var position = 0;

        
        while (heightLeft >= 0) {
            doc.addImage(imgData, 'PNG', 0, position, imgWidth, imgHeight);
            heightLeft -= pageHeight;
            if (heightLeft > 0) {
                doc.addPage(); // 다음 페이지 추가
            }
            position -= 297; // A4 페이지 크기
        }

        doc.save('full_Page_report.pdf');
    });
}



    
    
    

</script>
</html>
