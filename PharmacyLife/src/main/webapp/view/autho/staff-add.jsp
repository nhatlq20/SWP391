<%-- 
    Document   : staff-add
    Created on : Feb 13, 2026, 1:20:29 PM
    Author     : anltc
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Thêm nhân viên</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/staff.css">
</head>
<body>

    <jsp:include page="/view/common/header.jsp"/>
    <jsp:include page="/view/common/sidebar.jsp"/>

    <div class="main-content staff-main" style="padding:20px; margin-top:110px;">
        <div class="staff-page">
            <div class="staff-header">
                <div class="staff-title">
                    <img src="${pageContext.request.contextPath}/assets/img/Manage.png" alt="manage" />
                    <div>Thêm nhân viên</div>
                </div>
            </div>

            <!-- Debug: Check roleList -->
            <div style="display:none;">
                RoleList size: ${roleList.size()}
                <c:forEach var="role" items="${roleList}">
                    Role: ${role.roleId} - ${role.roleName}
                </c:forEach>
            </div>

            <div class="staff-card" style="max-width: 600px; margin: 0 auto;">
                <form method="POST" action="${pageContext.request.contextPath}/Staffmanage?action=insert" class="staff-form">
                    
                    <div class="form-group">
                        <label for="staffName">
                            <span style="display:inline-flex; align-items:center; gap:4px;">
                                <img src="${pageContext.request.contextPath}/assets/img/fname.png" alt="Name" style="width:20px; height:20px;" /> Họ và tên nhân viên
                            </span>
                        </label>
                        <input type="text" id="staffName" name="staffName" placeholder="Họ và tên nhân viên" required style="width:100%; padding:10px; border:1px solid #ddd; border-radius:6px; font-size:14px; box-sizing:border-box;">
                    </div>

                    <div class="form-group">
                        <label for="staffEmail">
                            <span style="display:inline-flex; align-items:center; gap:4px;">
                                <img src="${pageContext.request.contextPath}/assets/img/email.png" alt="Email" style="width:20px; height:20px;" /> Email
                            </span>
                        </label>
                        <input type="email" id="staffEmail" name="staffEmail" placeholder="Email nhân viên" required style="width:100%; padding:10px; border:1px solid #ddd; border-radius:6px; font-size:14px; box-sizing:border-box;">
                    </div>

                    <div class="form-group">
                        <label for="staffPassword">
                            <span style="display:inline-flex; align-items:center; gap:4px;">
                                <img src="${pageContext.request.contextPath}/assets/img/pass.png" alt="Password" style="width:20px; height:20px;" /> Mật khẩu
                            </span>
                        </label>
                        <input type="password" id="staffPassword" name="staffPassword" placeholder="Mật khẩu" required style="width:100%; padding:10px; border:1px solid #ddd; border-radius:6px; font-size:14px; box-sizing:border-box;">
                    </div>

                    <div class="form-group">
                        <label>
                            <span style="display:inline-flex; align-items:center; gap:4px;">
                                <img src="${pageContext.request.contextPath}/assets/img/role.png" alt="Role" style="width:20px; height:20px;" /> Chức vụ
                            </span>
                        </label>
                        <div style="width:100%; padding:10px; background:#f5f5f5; border-radius:6px; font-size:14px; color:#666;">
                            Nhân viên
                        </div>
                    </div>

                    <div class="form-actions" style="display:flex; gap:12px; justify-content:center; margin-top:30px;">
                        <a href="${pageContext.request.contextPath}/Staffmanage" class="btn-cancel" style="padding:10px 28px; background:#9CA3AF; color:white; border:none; border-radius:18px; text-decoration:none; cursor:pointer; font-weight:600;">Hủy bỏ</a>
                        <button type="submit" class="btn-submit" style="padding:10px 28px; background:#4B9BFF; color:white; border:none; border-radius:18px; cursor:pointer; font-weight:600;">⊕ Thêm</button>
                    </div>

                </form>
            </div>
        </div>
    </div>

    <style>
        .staff-form {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .form-group label {
            font-weight: 600;
            font-size: 14px;
            color: #333;
        }

        .form-group input,
        .form-group select {
            transition: border-color 0.3s;
        }

        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #4B9BFF;
            box-shadow: 0 0 0 3px rgba(75, 155, 255, 0.1);
        }

        .btn-cancel:hover {
            background: #7B8A99;
        }

        .btn-submit:hover {
            background: #357ABD;
        }
    </style>

</body>
</html>

