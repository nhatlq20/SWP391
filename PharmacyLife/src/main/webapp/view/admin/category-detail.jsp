<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html>

            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                <title>Chi tiết danh mục</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
                <style>
                    body {
                        background: #f1f3f8;
                    }

                    .sidebar-wrapper {
                        top: 115px !important;
                        height: calc(100vh - 115px) !important;
                        z-index: 100;
                    }

                    .main-content {
                        margin-left: 275px;
                        margin-top: 115px;
                        padding: 20px;
                    }

                    .top-row {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        margin-bottom: 20px;
                    }

                    .category-badge {
                        padding: 8px 18px;
                        border-radius: 999px;
                        color: #fff;
                        background: linear-gradient(90deg, #4f81e1, #31d2d7);
                        font-weight: 600;
                        font-size: 14px;
                        box-shadow: 0 8px 18px rgba(79, 129, 225, 0.28);
                        display: inline-block;
                    }

                    .btn-back {
                        border-radius: 999px;
                        min-width: 96px;
                    }

                    .card {
                        border-radius: 16px;
                        border: 1px solid #d6dae3;
                        box-shadow: 0 4px 12px rgba(0, 0, 0, .04);
                    }

                    .table thead th {
                        background: #eceef3;
                        border-top: none;
                        font-size: 18px;
                        font-weight: 700;
                        color: #242833;
                        padding: 14px 12px;
                        vertical-align: middle;
                    }

                    .table tbody td {
                        font-size: 16px;
                        color: #2f3441;
                        vertical-align: middle;
                        padding: 14px 12px;
                    }

                    .medicine-img {
                        width: 70px;
                        height: 52px;
                        object-fit: contain;
                    }

                    .price {
                        color: #0a9d2a;
                        font-weight: 700;
                    }
                </style>
            </head>

            <body>
                <jsp:include page="/view/common/header.jsp" />
                <jsp:include page="/view/common/sidebar.jsp" />

                <div class="main-content">
                    <div class="top-row">
                        <span class="category-badge">
                            <c:out value="${category.categoryCode}" default="N/A" />
                        </span>
                        <a class="btn btn-secondary btn-back"
                            href="${pageContext.request.contextPath}/category?action=list">Trở lại</a>
                    </div>

                    <div class="card">
                        <div class="card-body p-4">
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead>
                                        <tr>
                                            <th style="width: 160px;">Mã</th>
                                            <th style="width: 190px;">Ảnh</th>
                                            <th>Tên thuốc</th>
                                            <th style="width: 170px;">Giá</th>
                                            <th style="width: 130px;">Đơn vị</th>
                                            <th style="width: 150px;">Số lượng</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${not empty medicineList}">
                                                <c:forEach items="${medicineList}" var="m">
                                                    <tr>
                                                        <td>${m.medicineCode}</td>
                                                        <td>
                                                            <img src=${pageContext.request.contextPath}${m.imageUrl}
                                                                alt="${m.medicineName}" class="medicine-img">
                                                        </td>
                                                        <td>${m.medicineName}</td>
                                                        <td class="price">
                                                            <fmt:formatNumber value="${m.sellingPrice}"
                                                                pattern="#,##0.0" />đ
                                                        </td>
                                                        <td>${m.unit}</td>
                                                        <td>${m.remainingQuantity}</td>
                                                    </tr>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <tr>
                                                    <td colspan="6" class="text-center text-muted py-4">Danh mục này
                                                        chưa có thuốc.</td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

            </body>

            </html>