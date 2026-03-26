<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
            <!DOCTYPE html>
            <html>

            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                <title>Chi tiết danh mục</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/category-detail.css">
                <style>
                    .btn-back {
                        background: #f59e0b;
                        color: #fff;
                        border: none;
                        border-radius: 10px;
                        padding: 10px 24px;
                        font-weight: 600;
                        text-decoration: none;
                        display: inline-flex;
                        align-items: center;
                        gap: 8px;
                        transition: all 0.2s;
                    }
                    .btn-back:hover {
                        background: #d97706;
                        color: #fff;
                    }
                </style>
            </head>

            <body>
                <jsp:include page="/view/common/header.jsp" />
                <jsp:include page="/view/common/sidebar.jsp" />

                <div class="main-content">
                    <div class="mb-4">
                        <h2 class="page-title"><i class="fas fa-list me-2 text-primary"></i>Chi tiết danh mục</h2>
                    </div>
                    <div class="category-meta-card mt-5 mb-3 ">
                        <div class="row g-3 align-items-center">
                            <div class="col-12 col-md-6 text-start">
                                <span class="category-info-label">Mã danh mục:</span>
                                <span class="category-info-value category-code-value ms-2">
                                    <c:choose>
                                        <c:when test="${not empty category.categoryCode}">
                                            <c:out value="${category.categoryCode}" />
                                        </c:when>
                                        <c:otherwise>Chưa có mã</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                            <div class="col-12 col-md-6 text-md-end text-start">
                                <span class="category-info-label">Tên danh mục:</span>
                                <span class="category-info-value ms-2"><c:out value="${category.categoryName}" /></span>
                            </div>
                        </div>
                    </div>

                    <div class="category-detail-card">
                        <div class="table-responsive">
                            <table class="table table-hover table-bordered medicine-table  mb-0">
                                <thead>
                                    <tr>
                                        <th>Mã thuốc</th>
                                        <th>Ảnh</th>
                                        <th>Tên thuốc</th>
                                        <th>Tồn kho theo đơn vị</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty medicineList}">
                                            <c:forEach items="${medicineList}" var="m">
                                                <tr>
                                                    <td><c:out value="${m.medicineCode}" /></td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty m.imageUrl}">
                                                                <c:set var="imageUrlTrimmed" value="${fn:trim(m.imageUrl)}" />
                                                                <c:choose>
                                                                    <c:when test="${fn:startsWith(imageUrlTrimmed, 'http://') or fn:startsWith(imageUrlTrimmed, 'https://')}">
                                                                        <img src="<c:out value='${imageUrlTrimmed}'/>" alt="<c:out value='${m.medicineName}'/>" class="medicine-img">
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <img src="${pageContext.request.contextPath}<c:out value='${imageUrlTrimmed}'/>" alt="<c:out value='${m.medicineName}'/>" class="medicine-img">
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-muted">-</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td><c:out value="${m.medicineName}" /></td>
                                                    <td>
                                                        <c:set var="units" value="${medicineUnits[m.medicineId]}" />
                                                        <c:choose>
                                                            <c:when test="${not empty units}">
                                                                <c:forEach items="${units}" var="unit" varStatus="unitStatus">
                                                                    <span class="unit-pill me-2 mb-1" title="Quy đổi: 1 ${unit.unitName} = ${unit.conversionRate} basic unit">
                                                                        <c:out value="${unit.unitName}" />:
                                                                        <c:choose>
                                                                            <c:when test="${unit.conversionRate > 0}">
                                                                                <c:set var="quantity" value="${m.remainingQuantity / unit.conversionRate}" />
                                                                                <fmt:formatNumber value="${quantity}" maxFractionDigits="0" />
                                                                            </c:when>
                                                                            <c:otherwise>0</c:otherwise>
                                                                        </c:choose>
                                                                    </span>
                                                                </c:forEach>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-muted">-</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="5" class="text-center text-muted py-4">Danh mục này chưa có thuốc.</td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="mt-2" style="margin-left: 330px; margin-bottom: 2rem;">
                        <a class="btn-back" href="${pageContext.request.contextPath}/category?action=list">
                            <i class="fas fa-chevron-left"></i> Trở lại
                        </a>
                    </div>
                </div>

            </body>

            </html>