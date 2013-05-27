<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<style type="text/css">
body,td,div{font-size:12px;font-familly:微软雅黑;}
#progressBar{width:400px;height:12px;background:#FFFFFF;border:1px solid #000000;padding:1px;}
#progressBarItem{width:30%;height:100%;background:#FF0000;}
</style>
</head>
<body>
<iframe name=uploadiframe width=0 height =0>
</iframe>
<form action="servlet/ProgressUploadServlet" method="post" enctype="multipart/form-data" target="uploadiframe"
onsubmit="showStatus();">
<input type="file" name="file1" style="whidth:350px;"><br/>
<input type="file" name="file2" style="whidth:350px;"><br/>
<input type="file" name="file3" style="whidth:350px;"><br/>
<input type="file" name="file4" style="whidth:350px;"><br/>
<input type="submit" value="开始上传" name="btnSubmit"><br/>
</form>
<div id="status" style="display:none;">
    上传进度条：
    <div id="progressBar" >
        <div id="progressBarItem"></div>
    </div>
    <div id="statusInfo" style="display:none;">
        <table >
            <tr>
                <td>已完成百分比：</td>
                <td id='completePercent'></td>
            </tr>
            <tr>
                <td>已完成数(M)：</td>
                <td id='completeLength'></td>
            </tr>
            <tr>
                <td>文件总长度(M)：</td>
                <td id='wholeLength'></td>
            </tr>
            <tr>
                <td>传输速度(K)：</td>
                <td id='speed'></td>
            </tr>
            <tr>
                <td>已用时间(s)：</td>
                <td id='usedTime'></td>
            </tr>
            <tr>
                <td>估计总时间(s)：</td>
                <td id='wholeTime'></td>
            </tr>
            <tr>
                <td>估计剩余时间(s)：</td>
                <td id='remainTime'></td>
            </tr>
            <tr>
                <td>正在上传第几个文件：</td>
                <td id='index'></td>
            </tr>
        </table>
    </div>
    
    <div id="finishDiv">
    </div>
    <script type="text/javascript">
        var finished=true;//上传是否结束
        function $(obj) {
           return document.getElementById(obj);//返回id=obj的html对象 
        }
        function showStatus() {
            finished=false;
            $('status').style.display = 'block';//显示进度条
            $('progressBarItem').style.width = '1%';//进度条置为1%
            $('btnSubmit').disable = true;

            setTimeout("requestStatus()",1000);//1秒后执行requestStatus()方法
        }
        function requestStatus() {//向服务器请求上传进度
  		if (finished) return;//如果已经结束，则返回
			var req = createRequest();//获取Ajax请求
			req.open("Get", "servlet/ProgressUploadServlet");//设置请求路径及请求方式GET
			req.onreadystatechange = function(){callBack(req);};//请求发送完毕执行callBack(req);
			req.send(null);
			setTimeout("requestStatus()",1000);//1秒后重新执行requestStatus()方法 
        }
        function createRequest() {
        	if (window.ActiveXObject) {    
                xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");    
            }    
            else if (window.XMLHttpRequest) {    
                xmlHttp = new XMLHttpRequest();    
            }
        }
        function callBack(req) {//刷新进度条
			if(req.readyState == 4) {//请求结束后
				if (req.status!=200) {//请求发生错误
				    debug("Error: req.Status:"+req.status);
				    return;
				}
				debug("status.jsp返回值："+req.responseText);
				var ss = req.responseText.split("||");//处理进度信息：百分比||已完成数||文件总长度(M)||传输数率(K)||已用时间(s)||
				//估计总时间(s)||估计剩余时间(s)||正在上传第几个文件
				$('progressBarItem').style.width = '' + ss[0] + '%' ;
				if (ss[1]==ss[2]) {
					finished=true;
					$('finishDiv').innerHTML = "<br/><br/>上传已完成！";
				} else {
					$('status').style.display = 'block';//显示
					$('completePercent').innerHTML = ss[0]+'%';
					$('completeLength').innerHTML = ss[1];
					$('wholeLength').innerHTML = ss[2];
					$('speed').innerHTML = ss[3];
					$('usedTime').innerHTML = ss[4];
					$('wholeTime').innerHTML = ss[5];
					$('remainTime').innerHTML = ss[6];
					$('index').innerHTML = ss[7];
				}
			}
        }
        function debug(obj) {
			var div = document.createElement("DIV");
			div.innerHTML = "[debug]:" + obj;
			document.body.appendChild(div);
        }
    </script>
</div>
</body>
</html>
