<%-- Document : staff-add Created on : Feb 13, 2026, 1:20:29 PM Author : anltc --%>

    <%@ page contentType="text/html;charset=UTF-8" %>
        <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
            <!DOCTYPE html>
            <html>

            <head>
                <title>Thêm nhân viên</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/staff.css">
                <style>
                    /* Balanced Override: Lowered slightly to prevent header overlap */
                    body .main-content.staff-main {
                        margin-top: 110px !important;
                        margin-left: 280px !important;
                        padding-top: 15px !important;
                        position: relative !important;
                        z-index: 1 !important;
                    }
                    @media (max-width: 1024px) {
                        .staff-main {
                            margin-left: 290px !important;
                            margin-top: 115px !important;
                        }
                    }

                    .staff-title-main {
                        display: flex !important;
                        align-items: center !important;
                        gap: 15px !important;
                        font-size: 24px !important;
                        font-weight: 700 !important;
                        color: #1e293b !important;
                        margin-bottom: 25px !important;
                    }

                    .staff-title-main img {
                        width: 32px !important;
                        height: 32px !important;
                        background: #1e293b;
                        border-radius: 6px;
                        padding: 4px;
                    }

                    /* High-End Form Styling based on screenshot - COMPACT version */
                    .staff-card.add-staff-card {
                        padding: 25px 40px !important; /* Reduced top/bottom padding */
                        max-width: 500px !important;
                        margin: 0 auto !important;
                        background: #ffffff !important;
                        border-radius: 24px !important;
                        box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.05), 0 8px 10px -6px rgba(0, 0, 0, 0.05) !important;
                        border: 1px solid #f1f5f9 !important;
                    }

                    .card-form-title {
                        color: #4B9BFF;
                        font-size: 24px; /* Slightly smaller title */
                        font-weight: 600;
                        text-align: center;
                        margin-bottom: 20px; /* Reduced margin */
                    }

                    .staff-form {
                        display: flex;
                        flex-direction: column;
                        gap: 12px !important; /* Reduced gap between groups */
                    }

                    .form-group {
                        margin-bottom: 0 !important;
                        display: flex;
                        flex-direction: column;
                        gap: 4px !important; /* Reduced internal gap */
                    }

                    .form-label-with-icon {
                        display: flex !important;
                        align-items: center !important;
                        gap: 10px !important;
                        font-size: 14px !important; /* Slightly smaller label */
                        color: #1e293b !important;
                        font-weight: 500 !important;
                    }

                    .form-label-with-icon img {
                        width: 16px !important; /* Smaller icons */
                        height: 16px !important;
                        opacity: 0.8;
                    }

                    .staff-input, .staff-readonly-field {
                        background-color: #f3f6f9 !important;
                        border: none !important;
                        border-radius: 10px !important;
                        padding: 10px 16px !important; /* More compact input padding */
                        font-size: 13px !important;
                        color: #475569 !important;
                        width: 100% !important;
                        box-sizing: border-box !important;
                        transition: all 0.2s ease !important;
                    }

                    .staff-input::placeholder {
                        color: #94a3b8 !important;
                    }

                    .staff-input:focus {
                        background-color: #ffffff !important;
                        box-shadow: 0 0 0 2px rgba(75, 155, 255, 0.2) !important;
                        outline: none !important;
                    }

                    .form-actions {
                        margin-top: 15px !important; /* Reduced margin before buttons */
                        display: flex;
                        justify-content: space-between !important;
                        align-items: center;
                    }

                    .btn-cancel {
                        background: #b0b0b0 !important;
                        color: #fff !important;
                        border-radius: 30px !important;
                        padding: 10px 35px !important;
                        text-decoration: none !important;
                        font-weight: 600 !important;
                        font-size: 15px !important;
                        transition: opacity 0.2s !important;
                    }

                    .btn-submit {
                        background: #4B9BFF !important;
                        color: white !important;
                        border: none !important;
                        border-radius: 30px !important;
                        padding: 10px 35px !important;
                        font-weight: 600 !important;
                        font-size: 15px !important;
                        cursor: pointer !important;
                        display: inline-flex !important;
                        align-items: center !important;
                        gap: 8px !important;
                        box-shadow: 0 4px 10px rgba(75, 155, 255, 0.3) !important;
                        transition: all 0.2s !important;
                    }

                    .btn-cancel:hover, .btn-submit:hover {
                        opacity: 0.9 !important;
                        transform: translateY(-1px);
                    }
                    
                    .add-btn-icon-small {
                        width: 14px;
                        height: 14px;
                        filter: brightness(0) invert(1);
                    }
                </style>
            </head>

            <body>

                <jsp:include page="/view/common/header.jsp" />
                <jsp:include page="/view/common/sidebar.jsp" />

                <div class="main-content staff-main">
                    <div class="staff-page">
                        <div class="staff-header">
                            <div class="staff-title-main">
                                <img src="${pageContext.request.contextPath}/assets/img/Manage.png" alt="manage" />
                                <div>Quản lí nhân viên</div>
                            </div>
                        </div>

                        <div class="staff-card add-staff-card">
                            <div class="card-form-title">Thêm nhân viên</div>
                            <form method="POST" action="${pageContext.request.contextPath}/manage-staff?action=insert"
                                class="staff-form">

                                <div class="form-group">
                                    <label for="staffName">
                                        <span class="form-label-with-icon">
                                            <img src="${pageContext.request.contextPath}/assets/img/fname.png"
                                                alt="Name" /> Họ và tên nhân viên
                                        </span>
                                    </label>
                                    <input type="text" id="staffName" name="staffName" placeholder="Họ và tên nhân viên"
                                        required class="staff-input">
                                </div>

                                <div class="form-group">
                                    <label>
                                        <span class="form-label-with-icon">
                                            <img src="${pageContext.request.contextPath}/assets/img/role.png" alt="Role" /> Chức vụ
                                        </span>
                                    </label>
                                    <div class="staff-readonly-field">
                                        Nhân viên
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="staffEmail">
                                        <span class="form-label-with-icon">
                                            <img src="${pageContext.request.contextPath}/assets/img/email.png"
                                                alt="Email" /> Email
                                        </span>
                                    </label>
                                    <input type="email" id="staffEmail" name="staffEmail" placeholder="Email nhân viên"
                                        required class="staff-input">
                                </div>

                                <div class="form-group">
                                    <label for="staffPassword">
                                        <span class="form-label-with-icon">
                                            <img src="${pageContext.request.contextPath}/assets/img/Lock.png"
                                                alt="Password" /> Mật khẩu
                                        </span>
                                    </label>
                                    <input type="password" id="staffPassword" name="staffPassword"
                                        placeholder="Mật khẩu" required class="staff-input">
                                </div>

                                <div class="form-actions">
                                    <a href="${pageContext.request.contextPath}/manage-staff" class="btn-cancel">Hủy</a>
                                    <button type="submit" class="btn-submit">
                                        <img class="add-btn-icon-small" src="${pageContext.request.contextPath}/assets/img/plus.png" alt="plus"> Thêm
                                    </button>
                                </div>

                            </form>
                        </div>
                    </div>
                </div>

            </body>

            </html>