<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html>

            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Quản lý đơn hàng - PharmacyLife</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/medicine-dashboard.css">
            </head>

            <body class="bg-light">
                <jsp:include page="/view/common/header.jsp" />
                <jsp:include page="/view/common/sidebar.jsp" />

                <div class="main-content">
                    <!-- Page Header: Title + Search -->
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h3 class="fw-bold mb-0"><i class="fas fa-shopping-bag me-2 text-primary"></i>Quản lí đơn hàng
                        </h3>
                        <div class="d-flex align-items-center gap-2">
                            <div class="search-box">
                                <i class="fas fa-search"></i>
                                <input type="text" id="orderSearchInput" placeholder="Tìm mã đơn, khách hàng..."
                                    oninput="filterTable()">
                            </div>
                            <button class="btn-action btn-view" title="Lọc" style="width:40px;height:40px;">
                                <i class="fas fa-filter"></i>
                            </button>
                        </div>
                    </div>

                    <!-- Statistics -->
                    <div class="stats-row">
                        <div class="stat-card stat-total">
                            <div class="stat-number">${orders.size()}</div>
                            <div class="stat-label">Tổng đơn hàng</div>
                        </div>
                        <div class="stat-card stat-low">
                            <c:set var="pendingCount" value="0" />
                            <c:forEach items="${orders}" var="o">
                                <c:if test="${o.status == 'Pending'}">
                                    <c:set var="pendingCount" value="${pendingCount + 1}" />
                                </c:if>
                            </c:forEach>
                            <div class="stat-number">${pendingCount}</div>
                            <div class="stat-label">Đang chờ</div>
                        </div>
                        <div class="stat-card stat-total">
                            <c:set var="processingCount" value="0" />
                            <c:forEach items="${orders}" var="o">
                                <c:if test="${o.status == 'Confirmed' || o.status == 'Shipping'}">
                                    <c:set var="processingCount" value="${processingCount + 1}" />
                                </c:if>
                            </c:forEach>
                            <div class="stat-number" style="color: #3b82f6;">${processingCount}</div>
                            <div class="stat-label">Đang xử lý/giao</div>
                        </div>
                        <div class="stat-card stat-instock">
                            <c:set var="deliveredCount" value="0" />
                            <c:forEach items="${orders}" var="o">
                                <c:if test="${o.status == 'Delivered'}">
                                    <c:set var="deliveredCount" value="${deliveredCount + 1}" />
                                </c:if>
                            </c:forEach>
                            <div class="stat-number">${deliveredCount}</div>
                            <div class="stat-label">Đã hoàn thành</div>
                        </div>
                    </div>

                    <!-- Orders Table Card -->
                    <div class="medicine-card">
                        <div class="table-responsive">
                            <table class="table medicine-table align-middle" id="orderTable">
                                <thead>
                                    <tr>
                                        <th class="ps-4">Mã đơn</th>
                                        <th>Khách hàng</th>
                                        <th>Ngày đặt</th>
                                        <th>Tổng tiền</th>
                                        <th>Trạng thái</th>
                                        <th class="text-center" style="width:100px">Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${orders}" var="o">
                                        <tr>
                                            <td class="ps-4"><strong>#${o.orderId}</strong></td>
                                            <td>
                                                <div class="medicine-name-cell">
                                                    <div class="name">${o.shippingName}</div>
                                                    <div class="desc">${o.shippingPhone}</div>
                                                </div>
                                            </td>
                                            <td>
                                                <fmt:formatDate value="${o.orderDate}" pattern="dd/MM/yyyy HH:mm" />
                                            </td>
                                            <td>
                                                <span class="price">
                                                    <fmt:formatNumber value="${o.totalAmount}" type="number"
                                                        groupingUsed="true" />₫
                                                </span>
                                            </td>
                                            <td>
                                                <c:set var="statusBadge" value="badge-secondary" />
                                                <c:set var="statusText" value="${o.status}" />
                                                <c:choose>
                                                    <c:when test="${o.status == 'Pending'}">
                                                        <c:set var="statusBadge" value="badge-pending" />
                                                        <c:set var="statusText" value="Chờ xử lý" />
                                                    </c:when>
                                                    <c:when test="${o.status == 'Confirmed'}">
                                                        <c:set var="statusBadge" value="badge-confirmed" />
                                                        <c:set var="statusText" value="Đã xác nhận" />
                                                    </c:when>
                                                    <c:when test="${o.status == 'Shipping'}">
                                                        <c:set var="statusBadge" value="badge-shipping" />
                                                        <c:set var="statusText" value="Đang giao hàng" />
                                                    </c:when>
                                                    <c:when test="${o.status == 'Delivered'}">
                                                        <c:set var="statusBadge" value="badge-delivered" />
                                                        <c:set var="statusText" value="Đã giao hàng" />
                                                    </c:when>
                                                    <c:when test="${o.status == 'Cancelled'}">
                                                        <c:set var="statusBadge" value="badge-cancelled" />
                                                        <c:set var="statusText" value="Đã hủy" />
                                                    </c:when>
                                                </c:choose>
                                                <span class="badge ${statusBadge}">${statusText}</span>
                                            </td>
                                            <td class="text-center">
                                                <a href="order-detail-dashboard?id=${o.orderId}"
                                                    class="btn-action btn-view" title="Xem chi tiết">
                                                    <i class="fas fa-eye"></i>
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                <script>
                    function filterTable() {
                        var input = document.getElementById('orderSearchInput').value.toLowerCase();
                        var rows = document.querySelectorAll('#orderTable tbody tr');
                        rows.forEach(function (row) {
                            var text = row.textContent.toLowerCase();
                            row.style.display = text.includes(input) ? '' : 'none';
                        });
                    }
                </script>
            </body>

            </html>