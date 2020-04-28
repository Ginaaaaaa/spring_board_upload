<%@page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="../includes/header.jsp"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@include file="../includes/header.jsp"%>

<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">Board Register</h1>
	</div>
</div>
	<style>
.uploadResult {
	width: 100%;
	background-color: gray;
}

.uploadResult ul {
	display: flex;
	flex-flow: row;
	justify-content: center;
	align-items: center;
}

.uploadResult ul li {
	list-style: none;
	padding: 10px;
}

.uploadResult ul li img {
	width: 100px;
}
</style>

<style>
.bigPictureWrapper {
  position: absolute;
  display: none;
  justify-content: center;
  align-items: center;
  top:0%;
  width:100%;
  height:100%;
  background-color: gray; 
  z-index: 100;
}

.bigPicture {
  position: relative;
  display:flex;
  justify-content: center;
  align-items: center;
}
</style>

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
		
			<div class="panel-heading">Board Register</div>
			<div class="panel-body">
				<form role="form" action="/board/register" method="post">
					<div class="form-group">
						<label>Title</label> <input class="form-control" name='title'>
					</div>
					
					<div class="form-group">
						<label>Text area</label>
						<textarea class="form-control" rows="3" name='content'></textarea>
					</div>
					
					<div class="form-group">
						<label>Writer</label>
						<input class="form-control" name='writer'>
					</div>
						<button type="submit" class="btn btn-default">Submit Button</button>
						<button type="reset" class="btn btn-default">Reset Button</button>
				</form>
			</div>
		</div>
	</div>
</div>

<div class="row">
  <div class="col-lg-12">
    <div class="panel panel-default">

      <div class="panel-heading">File Attach</div>
      <!-- /.panel-heading -->
      <div class="panel-body">
        <div class="form-group uploadDiv">
            <input type="file" name='uploadFile' multiple>
        </div>
        
        <div class='uploadResult'> 
          <ul>
          
          </ul>
        </div>
        
        
      </div>
      <!--  end panel-body -->

    </div>
    <!--  end panel-body -->
  </div>
  <!-- end panel -->
</div>
<!-- /.row -->
<script>
$(document).ready(function(e){
	var formObj = $("form[role='form']");
	$("button[type='submit']").on("click", function(e){
		e.preventDefault();
		console.log("submit clicked");
	});
	var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
	var maxSize = 5242880; //5MB
	
	function checkExtension(fileName, fileSize){
		
		if(fileSize >= maxSize){
			alert("파일 사이즈 초과");
			return false;
		}
		
		if(regex.test(fileName)){
			alert("해당 종류의 파일은 업로드 할 수 없습니다.");
			return false;
		}
		return true;
	}
	
	$("input[type='file']").change(function(e){
		var formData = new FormData();
		
		var inputFile = $("input[name='uploadFile']");
		
		var files = inputFile[0].files;
		
		for(var i = 0; i < files.length; i++){
			
			if(!checkExtension(files[i].name, files[i].size )){
				return false;
			}
			formData.append("uploadFile", files[i]);
		}
		
		$.ajax({
			url: '/uploadAjaxAction',
			processData: false,
			contentType: false,data:
			formData,type: 'POST',
			dataType:'json',
			success: function(result){
			console.log(result);
					
			showUploadResult(result);
				}
		}); //$.ajax
		
	});
	function showUploadResult(uploadResultArr){
		if(!uploadResultArr || uploadResultArr.length == 0){
			return;
		}
		var uploadUL = $(".uploadResult ul");
		
		var str = "";
		
		$(uploadResultArr).each(function(i, obj){
			
			//image type
			if(obj.image){
				var fileCallPath = encodeURIComponent(obj.uploadPath+ "/s_"+obj.uuid +"_"+obj.fileName);
				str += "<li><div>";
				str += "<span> "+ obj.fileName+"</span>";
				str += "<button type='button' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
				str += "<img src='/display?fileName="+fileCallPath+"'>";
				str +="</div>";
				str +"</li>";
			}else{
				var fileCallPath = encodeURIComponent(obj.uploadPath+"/"+obj.uuid+"_"+obj.fileName);
				var fileLink = fileCallPath.replace(new RegExp(/\\/g),"/");
				
				str +="<li><div>";
				str +="<span>"+obj.fileName+"</span>";
				str +="<button type='button' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
				str += "<img src='/resources/img/attach.png'></a>";
				str += '</div>';
				str +"</li>";
			}
		});
		uploadUL.append(str);
	}
});


</script>
<%@include file="../includes/footer.jsp"%>
