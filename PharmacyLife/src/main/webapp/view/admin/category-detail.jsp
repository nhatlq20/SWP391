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
            </head>

            <body>
                <jsp:include page="/view/common/header.jsp" />
                <jsp:include page="/view/common/sidebar.jsp" />

                <div class="main-content">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2 class="page-title"><i class="fas fa-list me-2 text-primary"></i>Chi tiết danh mục</h2>
                        <a class="btn btn-secondary btn-back" href="${pageContext.request.contextPath}/category?action=list"><i class="fas fa-arrow-left me-1"></i>Trở lại</a>
                    </div>
                    <div class="category-detail-card">
                        <div class="row mb-4">
                            <div class="col-12 col-md-6 text-start">
                                <span class="category-info-label">Mã danh mục:</span>
                                <span class="category-info-value ms-2"><c:out value="${category.categoryCode}" /></span>
                            </div>
                            <div class="col-12 col-md-6 text-end">
                                <span class="category-info-label">Tên danh mục:</span>
                                <span class="category-info-value ms-2"><c:out value="${category.categoryName}" /></span>
                            </div>
                        </div>
                        <div class="table-responsive">
                            <table class="table table-hover table-bordered medicine-table align-middle mb-0">
                                <thead>
                                    <tr>
                                        <th class="medicine-code-col">Mã thuốc</th>
                                        <th>Ảnh</th>
                                        <th>Tên thuốc</th>
                                        <th>Giá</th>
                                        <th>Đơn vị</th>
                                        <th>Số lượng</th>
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
                                                    <td class="price">
                                                        <c:choose>
                                                            <c:when test="${m.sellingPrice gt 0}">
                                                                <fmt:formatNumber value="${m.sellingPrice}" pattern="#,##0.0" />đ
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-muted">-</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty m.unit}">
                                                                <c:out value="${m.unit}" />
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-muted">-</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td><c:out value="${m.remainingQuantity}" /></td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="6" class="text-center text-muted py-4">Danh mục này chưa có thuốc.</td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

            </body>

            </html>