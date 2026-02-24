<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html>

            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                <title>Quản lý nhập thuốc</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/import.css">
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

                                <div class="action-bar">
                                    <div class="search-filter">
                                        <form method="POST" action="${pageContext.request.contextPath}/import"
                                            style="display: flex; gap: 10px; flex: 1; max-width: 500px;">
                                            <input type="hidden" name="action" value="search">
                                            <input type="text" name="keyword" class="search-input"
                                                placeholder="Tìm mã phiếu, nhà cung cấp..."
                                                value="${param.keyword != null ? param.keyword : ''}">
                                            <button type="button" class="filter-btn"
                                                style="cursor: pointer;">🔽</button>
                                        </form>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/import?action=create"
                                        class="btn-primary">
                                        <span style="font-size: 18px; font-weight: bold;">+</span>
                                        <span>Tạo phiếu nhập thuốc</span>
                                    </a>
                                </div>

                                <c:if test="${not empty error}">
                                    <div
                                        style="background-color: #f8d7da; color: #721c24; padding: 15px; border-radius: 5px; margin-bottom: 20px;">
                                        ${error}
                                    </div>
                                </c:if>

                                <div class="table-container">
                                    <table class="table">
                                        <thead>
                                            <tr>
                                                <th>Mã</th>
                                                <th>Nhà cung cấp</th>
                                                <th>Ngày nhập</th>
                                                <th>Tổng tiền</th>
                                                <th>Trạng thái</th>
                                                <th>Thao tác</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:choose>
                                                <c:when test="${not empty imports}">
                                                    <c:forEach var="imp" items="${imports}">
                                                        <tr>
                                                            <td>${imp.importCode}</td>
                                                            <td>${imp.supplierName != null ? imp.supplierName :
                                                                imp.supplierId}</td>
                                                            <td>
                                                                <fmt:formatDate value="${imp.importDate}"
                                                                    pattern="dd/MM/yyyy" />
                                                            </td>
                                                            <td class="amount-green">
                                                                <fmt:formatNumber value="${imp.totalAmount}"
                                                                    type="number" groupingUsed="true"
                                                                    maxFractionDigits="0" />₫
                                                            </td>
                                                            <td>
                                                                <c:set var="statusClass" value="status-pending" />
                                                                <c:if test="${imp.status == 'Đã duyệt'}">
                                                                    <c:set var="statusClass" value="status-approved" />
                                                                </c:if>
                                                                <c:if
                                                                    test="${imp.status == 'Chưa duyệt' || imp.status == 'Đã hủy'}">
                                                                    <c:set var="statusClass" value="status-cancelled" />
                                                                </c:if>
                                                                <span class="${statusClass}">${imp.status != null ?
                                                                    imp.status : 'Đang chờ'}</span>
                                                            </td>

                                                            <td>
                                                                <div class="action-buttons">
                                                                    <a href="${pageContext.request.contextPath}/import?action=view&code=${imp.importCode}"
                                                                        class="action-btn view-btn"
                                                                        title="Xem chi tiết">👁</a>
                                                                    <a href="${pageContext.request.contextPath}/import?action=edit&code=${imp.importCode}"
                                                                        class="action-btn edit-btn"
                                                                        title="Chỉnh sửa">✏</a>
                                                                    <a href="${pageContext.request.contextPath}/import?action=delete&code=${imp.importCode}"
                                                                        class="action-btn delete-btn"
                                                                        onclick="return confirm('Bạn có chắc chắn muốn xóa phiếu nhập này?')"
                                                                        title="Xóa">🗑</a>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise>
                                                    <tr>
                                                        <td colspan="6" class="empty-state">
                                                            <div>
                                                                <i>📋</i>
                                                                <p>Không có dữ liệu</p>
                                                            </div>
                                                        </td>
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