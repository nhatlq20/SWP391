<%-- 
    Document   : staff-detail
    Created on : Feb 13, 2026, 1:21:06 PM
    Author     : anltc
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <title>Chi tiết nhân viên</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/staff.css">
</head>
<body>

<jsp:include page="/view/common/header.jsp" />
<jsp:include page="/view/common/sidebar.jsp" />

<div class="main-content staff-main" style="padding:20px; margin-top:110px;">
    <div class="staff-page">
        <div class="staff-header">
            <div class="staff-title">
                <img src="${pageContext.request.contextPath}/assets/img/Manage.png" alt="manage" />
                <div>Quản lí nhân viên</div>
            </div>
           
        </div>

        <div class="detail-card">
            <h2 style="text-align:center; color:#2b7cff;">Xem chi tiết nhân viên</h2>

            <div class="detail-grid">
                <div class="form-field">
                    <label>Họ và tên</label>
                    <div class="field-box">${staff.staffName}</div>
                </div>
                <div class="form-field">
                    <label>Số điện thoại</label>
                    <div class="field-box">${staff.staffPhone}</div>
                </div>

                <div class="form-field">
                    <label>Giới tính</label>
                    <div class="field-box">${staff.staffGender}</div>
                </div>
                <div class="form-field">
                    <label>Ngày sinh</label>
                    <div class="field-box">none</div>
                </div>

                <div class="form-field wide">
                    <label>Email</label>
                    <div class="field-box">${staff.staffEmail}</div>
                </div>

                <div class="form-field wide">
                    <label>Địa chỉ</label>
                    <div class="field-box">none</div>
                </div>

            </div>

            <div style="text-align:right; margin-top:18px;">
                <a class="add-btn" href="${pageContext.request.contextPath}/Staffmanage">Đóng</a>
            </div>
        </div>

    </div>
</div>

</body>
</html>

