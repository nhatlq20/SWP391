<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html>

            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Quản lý khách hàng - PharmacyLife</title>
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
                        <h3 class="fw-bold mb-0"><i class="fas fa-users me-2 text-primary"></i>Quản lí khách hàng</h3>
                        <div class="d-flex align-items-center gap-2">
                            <div class="search-box">
                                <i class="fas fa-search"></i>
                                <input type="text" id="customerSearchInput" placeholder="Tìm tên khách hàng, email..."
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
                            <div class="stat-number">${customers.size()}</div>
                            <div class="stat-label">Tổng khách hàng</div>
                        </div>
                        <div class="stat-card stat-instock">
                            <c:set var="activeCount" value="0" />
                            <c:forEach items="${customers}" var="c">
                                <c:if test="${c.status}">
                                    <c:set var="activeCount" value="${activeCount + 1}" />
                                </c:if>
                            </c:forEach>
                            <div class="stat-number">${activeCount}</div>
                            <div class="stat-label">Hoạt động</div>
                        </div>
                        <div class="stat-card stat-out">
                            <c:set var="inactiveCount" value="0" />
                            <c:forEach items="${customers}" var="c">
                                <c:if test="${!c.status}">
                                    <c:set var="inactiveCount" value="${inactiveCount + 1}" />
                                </c:if>
                            </c:forEach>
                            <div class="stat-number">${inactiveCount}</div>
                            <div class="stat-label">Ngừng hoạt động</div>
                        </div>
                    </div>

                    <!-- Customers Table Card -->
                    <div class="medicine-card">
                        <div class="table-responsive">
                            <table class="table medicine-table align-middle" id="customerTable">
                                <thead>
                                    <tr>
                                        <th class="ps-4">Mã KH</th>
                                        <th>Họ và tên</th>
                                        <th>Liên hệ</th>
                                        <th>Địa chỉ</th>
                                        <th>Trạng thái</th>
                                        <th class="text-center" style="width:100px">Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${customers}" var="c">
                                        <tr>
                                            <td class="ps-4"><strong>${c.customerCode}</strong></td>
                                            <td>
                                                <div class="medicine-name-cell">
                                                    <div class="name">${c.fullName}</div>
                                                </div>
                                            </td>
                                            <td>
                                                <div><i class="fas fa-envelope me-1 text-muted" style="width:14px"></i>
                                                    ${c.email}</div>
                                                <div class="desc"><i class="fas fa-phone me-1 text-muted"
                                                        style="width:14px"></i> ${c.phone}</div>
                                            </td>
                                            <td>
                                                <div class="desc" style="-webkit-line-clamp: 2;">${c.address}</div>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${c.status}">
                                                        <span class="badge badge-stock">Hoạt động</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-out">Khóa</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-center">
                                                <a href="customer-detail-dashboard?id=${c.customerId}"
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
                        var input = document.getElementById('customerSearchInput').value.toLowerCase();
                        var rows = document.querySelectorAll('#customerTable tbody tr');
                        rows.forEach(function (row) {
                            var text = row.textContent.toLowerCase();
                            row.style.display = text.includes(input) ? '' : 'none';
                        });
                    }
                </script>
            </body>

            </html>