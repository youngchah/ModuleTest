<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/jspdf-autotable@3.8.2/dist/jspdf.plugin.autotable.min.js"></script>
<script src="${pageContext.request.contextPath }/resources/pdfFont/pdfFonts.js"></script>
</head>
<body>
	<form action="" method="post" id="mainForm">
		<p>userId : <input type="text" id="userId" value="a001" name="userId"/></p>
		<p>password : <input type="text" id="password" value="1234" name="password"/></p>
	</form>
	<button id="download">PDF다운로드</button>
	<button id="captureBtn">화면 캡쳐 PDF다운로드</button>
	
<script>


$(function(){
	var download = $("#download");
	var capture = $("#capture");
	window.jsPDF = window.jspdf.jsPDF;
	
	
	//문서 그려서 다운로드
	download.on("click", function(){

		var doc = new jsPDF("p", "mm", "a4");
		
		doc.addFileToVFS('malgun.ttf', fonts["malgun.ttf"]);  //_fonts 변수는 Base64 형태로 변환된 내용입니다.
		doc.addFont('malgun.ttf','malgun', 'normal');
		doc.setFont('malgun'); 
		
		doc.line(15, 19, 195, 19); // 선그리기(시작x, 시작y, 종료x, 종료y)
		doc.text(15, 40, '안녕하세요'); // 글씨입력(시작x, 시작y, 내용)
		doc.save('web.pdf');  //결과 출력
		
	});
	
	
	// 화면 캡쳐 다운로드
	$(document).ready(function(){
	    $("#captureBtn").click(function(){
	        captureAndDownloadPDF();
	    });
	});
	function captureAndDownloadPDF() {
	    // 화면을 캡처하여 canvas에 그린다
	    html2canvas(document.body).then(function(canvas) {
	        // 캡처된 canvas를 PDF로 변환
	        const imgData = canvas.toDataURL('image/png');
	        const pdf = new jsPDF('p', 'mm', 'a4');
	        const imgWidth = 210; // A4 크기
	        const imgHeight = canvas.height * imgWidth / canvas.width;
	        pdf.addImage(imgData, 'PNG', 0, 0, imgWidth, imgHeight);
	        // PDF 파일을 다운로드
	        pdf.save("full_page_capture.pdf");
	    });
	}
	   
});

</script>
</body>
</html>