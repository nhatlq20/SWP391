<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html>

            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                <title>Xem chi tiết phiếu nhập</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/import.css">
                <style>
                    /* Specific overrides for the View Details Card to match screenshot */
                    .view-card {
                        background-color: white;
                        border-radius: 12px;
                        padding: 40px;
                        max-width: 900px;
                        margin: 0 auto;
                        /* Center horizontally in the main content */
                        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
                    }

                    .view-title-center {
                        text-align: center;
                        color: #4a86e8;
                        font-size: 28px;
                        font-weight: bold;
                        margin-bottom: 40px;
                    }

                    .view-grid {
                        display: grid;
                        grid-template-columns: 1fr 1fr;
                        gap: 30px;
                        /* Horizontal and Vertical gap */
                        margin-bottom: 30px;
                    }

                    .view-label {
                        display: block;
                        margin-bottom: 10px;
                        font-weight: 600;
                        color: #333;
                        font-size: 15px;
                    }

                    .view-input-readonly {
                        width: 100%;
                        padding: 12px 15px;
                        background-color: #f1f3f5;
                        /* Light gray from screenshot */
                        border: none;
                        border-radius: 8px;
                        font-size: 14px;
                        color: #555;
                        font-weight: 500;
                    }

                    .view-close-btn {
                        background-color: #999;
                        color: white;
                        border: none;
                        padding: 10px 30px;
                        border-radius: 20px;
                        font-size: 16px;
                        cursor: pointer;
                        font-weight: bold;
                        transition: background 0.2s;
                        text-decoration: none;
                        display: inline-block;
                    }

                    .view-close-btn:hover {
                        background-color: #888;
                    }

                    .view-footer {
                        display: flex;
                        justify-content: flex-end;
                        margin-top: 40px;
                    }
                </style>
            </head>

            <body>
                <%@include file="header.jsp" %>

                    <div class="container">
                        <%@include file="sidebar.jsp" %>

                            <div class="main-content">
                                <div class="page-title">
                                    <i>📥</i>
                                    <span>Quản lý nhập thuốc</span>
                                </div>

                                <c:if test="${empty import}">
                                    <div
                                        style="background-color: #f8d7da; color: #721c24; padding: 15px; border-radius: 5px; margin-bottom: 20px;">
                                        Không tìm thấy phiếu nhập
                                    </div>
                                    <a href="${pageContext.request.contextPath}/ImportController"
                                        class="btn-secondary">Trở lại</a>
                                </c:if>

                                <c:if test="${not empty import}">
                                    <div class="view-card">
                                        <div class="view-title-center">Xem chi tiết phiếu nhập</div>

                                        <div class="view-grid">
                                            <!-- Row 1 -->
                                            <div>
                                                <label class="view-label">Mã</label>
                                                <input type="text" class="view-input-readonly"
                                                    value="${import.importCode}" readonly>
                                            </div>
                                            <div>
                                                <label class="view-label">Nhà cung cấp</label>
                                                <input type="text" class="view-input-readonly"
                                                    value="${import.supplierName != null ? import.supplierName : import.supplierId}"
                                                    readonly>
                                            </div>

                                            <div>
                                                <label class="view-label">Người nhập</label>
                                                <input type="text" class="view-input-readonly"
                                                    value="${import.staffName != null ? import.staffName : import.staffId}"
                                                    readonly>
                                            </div>
                                            <div>
                                                <label class="view-label">Ngày nhập</label>
                                                <input type="text" class="view-input-readonly"
                                                    value="<fmt:formatDate value='${import.importDate}' pattern='dd/MM/yyyy'/>"
                                                    readonly>
                                            </div>

                                            <!-- Row 3 -->
                                            <div>
                                                <label class="view-label">Tổng tiền</label>
                                                <input type="text" class="view-input-readonly"
                                                    value="<fmt:formatNumber value='${import.totalAmount}' type='number' maxFractionDigits='0'/>₫"
                                                    readonly>
                                            </div>
                                            <div>
                                                <label class="view-label">Trạng thái</label>
                                                <input type="text" class="view-input-readonly"
                                                    value="${import.status != null ? import.status : 'Đã duyệt'}"
                                                    readonly>
                                                <!-- Note: Status might not make sense if not in DB, defaulting to 'Đã duyệt' as in screenshot/requirement context -->
                                            </div>
                                        </div>

                                        <!-- Medicine List (Optional but recommended for 'Details') -->
                                        <c:if test="${not empty details}">
                                            <div
                                                style="margin-top: 40px; border-top: 1px solid #eee; padding-top: 20px;">
                                                <label class="view-label"
                                                    style="font-size: 18px; margin-bottom: 20px;">Danh sách
                                                    thuốc</label>
                                                <table class="clean-table">
                                                    <thead>
                                                        <tr>
                                                            <th>Mã thuốc</th>
                                                            <th>Tên thuốc</th>
                                                            <th>Số lượng</th>
                                                            <th>Giá</th>
                                                            <th>Thành tiền</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach var="detail" items="${details}">
                                                            <tr>
                                                                <td>${detail.medicineCode}</td>
                                                                <td>${detail.medicineName != null ? detail.medicineName
                                                                    : '-'}</td>
                                                                <td>${detail.quantity}</td>
                                                                <td class="amount-green">
                                                                    <fmt:formatNumber value="${detail.price}"
                                                                        type="number" maxFractionDigits="0" />₫
                                                                </td>
                                                                <td class="amount-green">
                                                                    <fmt:formatNumber value="${detail.totalAmount}"
                                                                        type="number" maxFractionDigits="0" />₫
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </c:if>

                                        <div class="view-footer">
                                            <a href="${pageContext.request.contextPath}/ImportController"
                                                class="view-close-btn">Đóng</a>
                                        </div>
                                    </div>
                                </c:if>
                            </div>
                    </div>
            </body>

            </html>