<!DOCTYPE html>
<html>
<head>
    <title>预警平台</title>
    <link rel="stylesheet" href="/static/css/bootstrap.min.css">
    <script src="static/js/sockjs-0.3.4.js"></script>
    <script src="static/js/stomp.js"></script>
    <script type="text/javascript" src="/static/js/jquery.min.js"></script>
<#--<script type="text/javascript" src="/static/js/index.js"></script>-->
    <script src="/static/js/bootstrap.min.js"></script>

    <style>
        .img_height{
            height:0px;
            padding-bottom:25%
        }
        /* Remove the navbar's default margin-bottom and rounded borders */
        .navbar {
            margin-bottom: 0;
            border-radius: 0;
        }

        /* Add a gray background color and some padding to the footer */
        footer {
            background-color: #f2f2f2;
            padding: 25px;
        }
    </style>
    <script>
        var stompClient = null;
        var pushContent = [];
        function timetrans(date){

            var date = new Date(date);//如果date为13位不需要乘1000
            var Y = date.getFullYear() + '-';
            var M = (date.getMonth()+1 < 10 ? '0'+(date.getMonth()+1) : date.getMonth()+1) + '-';
            var D = (date.getDate() < 10 ? '0' + (date.getDate()) : date.getDate()) + ' ';
            var h = (date.getHours() < 10 ? '0' + date.getHours() : date.getHours()) + ':';
            var m = (date.getMinutes() <10 ? '0' + date.getMinutes() : date.getMinutes()) + ':';
            var s = (date.getSeconds() <10 ? '0' + date.getSeconds() : date.getSeconds());
            return Y+M+D+h+m+s;
        }
        function connect() {
            var socket = new SockJS('/hello');
            stompClient = Stomp.over(socket);
            stompClient.connect({}, function (frame) {
//                setConnected(true);
                console.log('Connected: ' + frame);
                stompClient.subscribe('/topic/greetings', function (data) {
                    var data = data.body;

                    //results可以是一张图片中的多个人脸
                    if (data.indexOf("results") != -1) {
                        var rootJson = JSON.parse(data);

//                        var newContent = '';
                        var showHtml = '';
                        for (var i = 0; i < rootJson.results.length; i++) {
                            var singleFace = rootJson.results[i];
                            if (singleFace) {
//                                var face = "data:image;base64," + singleFace["face"];
                                var face = singleFace["face"];
                                var photo = singleFace["photo"];
                                showHtml =
                                        '<div class="col-xs-4 col-sm-4 img_height">' +
                                        '<div class="col-xs-12">' +
                                        '<div class="col-xs-4"><img class="col-xs-12 thumbnail" src="' + face + '"/><p>切出人脸图</p></div>' +
                                        '<div class="col-xs-4"><img class="col-xs-12 thumbnail" src="' + singleFace["matchFace"] + '"/><p>库中图</p></div>' +
                                        '<div class="col-xs-4"><img class="col-xs-12 thumbnail" onclick="showImageDetail(this)" src="' + photo + '"/><p>原图</p>' +
                                        '</div>' +
                                        '</div>' +
                                        '<div class="col-xs-12">' +
                                        '<p>相似度:' + singleFace["confidence"] + '</p>' +
                                        '<p>姓名:' + singleFace["meta"] + '</p>' +
                                        '<p>时间:' + timetrans(parseInt(singleFace["timestamp"].$numberLong)) + '</p>' +
                                        '<p>摄像头:' + singleFace["camera"] + '</p>' +
                                        '</div>' +
                                        '</div>'
                                if (pushContent.length < 9) {
                                    pushContent[pushContent.length] = showHtml;
                                } else {
                                    pushContent.shift();
                                    pushContent.push(showHtml);
                                }

                            }
                        }
                        var tmp = pushContent.slice(0);
                        var reverse = tmp.reverse();
                        $('#showIdentifyResults').html(reverse.join(''));
//                    console.log(greeting);
                    };
                });
            },function(message) {
                console.log("连接断开")
                setTimeout("connect()", 1000);
            })
        }

        connect();
        stompClient.onclose = function () {
//            setTimeout(function () {
//                connect();
//            },1000);
            console.log("连接关闭")

        }
        //        stompClient.on
        //        stompClient.disconnect(function () {
        //            console.log("连接断开")
        //        })
    </script>
</head>

<nav class="navbar navbar-inverse">
    <div class="container-fluid">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="#">预警平台</a>
        </div>
        <div class="collapse navbar-collapse" id="myNavbar">
            <ul class="nav navbar-nav">
                <li><a href="http://u1961b1648.51mypc.cn:24850" target="view_window">布防管理</a></li>
                <li><a href="/anytec/historyManager" target="view_window">查询历史</a></li>
                <li><a href="/anytec/portraitSearch" target="_blank">人像检索</a></li>
            </ul>
        <#--<ul class="nav navbar-nav navbar-right">-->
        <#--<li><a href="#"><span class="glyphicon glyphicon-log-in"></span> Login</a></li>-->
        <#--</ul>-->
        </div>
    </div>
</nav>

<div class="jumbotron">
    <div class="container text-center">
        <h1>预警平台</h1>
    </div>
</div>
<div id="outerdiv"
     style="position:fixed;top:0;left:0;background:rgba(0,0,0,0.7);z-index:2;width:100%;height:100%;display:none;">
    <div id="innerdiv" style="position:absolute;">
        <img id="bigimg" style="border:5px solid #fff;" src=""/>
    </div>
</div>
<div class="container-fluid bg-3 text-center">
    <div class="row" id="showIdentifyResults">
        <div class="col-xs-4 col-sm-4">
        <#--<div class="col-xs-4">-->
                <#--<img class="col-xs-12 thumbnail" src="/static/img/system_demo.png">-->
                <#--<p>切出人脸图</p>-->
            <#--</div>-->
            <#--<div class="col-xs-4">-->
                <#--<img class=" col-xs-12 thumbnail" src="/static/img/system_demo.png">-->
                <#--<p>库中图</p>-->
            <#--</div>-->
            <#--<div class="col-xs-4">-->
                <#--<img class="col-xs-12 thumbnail" src="/static/img/system_demo.png">-->
                <#--<p>原图</p>-->
            <#--</div>-->
            <#--<div class="col-xs-12">-->
                <#--<p>相似度</p>-->
                <#--<p>摄像头</p>-->
                <#--<p>姓名</p>-->
                <#--<p>时间</p>-->
            <#--</div>-->
        </div>
    </div>
</div>

<#--<body onload="disconnect()">-->
<#--<noscript><h2 style="color: #ff0000">Seems your browser doesn't support Javascript! Websocket relies on Javascript being enabled. Please enable-->
<#--Javascript and reload this page!</h2></noscript>-->
<#--<div>-->
<#--<div>-->
<#--<button id="connect" onclick="connect();">Connect</button>-->
<#--<button id="disconnect" disabled="disabled" onclick="disconnect();">Disconnect</button>-->
<#--</div>-->
<#--<div id="conversationDiv">-->
<#--<label>What is your name?</label><input type="text" id="name" />-->
<#--<button id="sendName" onclick="sendName();">Send</button>-->
<#--<p id="response"></p>-->
<#--</div>-->
<#--</div>-->
<#--</body>-->
</html>
