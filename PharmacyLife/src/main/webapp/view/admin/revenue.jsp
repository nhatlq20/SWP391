<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html>

            <head>
                <title>Quản lí doanh thu</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/revenue-dashboard.css">
            </head>

            <body>
                <!-- ================= HEADER ================= -->
                <jsp:include page="/view/common/header.jsp" />

                <div class="admin-layout">
                    <!-- =============== SIDEBAR =============== -->
                    <div class="sidebar-fixed">
                        <jsp:include page="/view/common/sidebar.jsp" />
                    </div>

                    <!-- ============= MAIN CONTENT ============= -->
                    <div class="main-content" style="margin-top:115px; padding-top:32px;">
                        <div class="container-fluid px-0">
                            <div class="d-flex align-items-center justify-content-between mb-4">
                                <h3 class="fw-bold mb-0"><i class="fas fa-chart-line me-2 text-primary"></i>Quản lí
                                    doanh thu</h3>

                                <form action="${pageContext.request.contextPath}/admin/revenue" method="GET"
                                    class="d-flex align-items-center gap-2">
                                    <label class="fw-bold mb-0">Từ ngày:</label>
                                    <input type="date" name="fromDate" value="${param.fromDate}" class="form-control"
                                        style="width:150px;">
                                    <label class="fw-bold mb-0">Đến ngày:</label>
                                    <input type="date" name="toDate" value="${param.toDate}" class="form-control"
                                        style="width:150px;">
                                    <button type="submit" class="btn btn-primary"><i class="fas fa-filter"></i>
                                        Lọc</button>
                                </form>
                            </div>
                            <!-- KPI Section Title -->
                            <div class="d-flex align-items-end mb-3" style="gap:12px;">
                                <div style="font-size:22px;font-weight:700;color:#2a60e8;">Tổng quan</div>
                            </div>
                            <!-- KPI Cards -->
                            <div class="row gap-24 mb-4">
                                <div class="col-12 col-sm-6 col-lg-3">
                                    <div class="kpi-card kpi-orders text-center">
                                        <div class="kpi-label">Số lượng đơn hàng</div>
                                        <div class="kpi-value-main">${totalOrders}</div>
                                        <div class="kpi-growth">
                                            <c:choose>
                                                <c:when test="${orderGrowth >= 0}">
                                                    <i class="fas fa-arrow-up text-success"></i>
                                                    <fmt:formatNumber value="${orderGrowth}" maxFractionDigits="0" />%
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="fas fa-arrow-down text-danger"></i>
                                                    <fmt:formatNumber value="${orderGrowth * -1}"
                                                        maxFractionDigits="0" />%
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-12 col-sm-6 col-lg-3">
                                    <div class="kpi-card kpi-value text-center">
                                        <div class="kpi-label">Giá trị đơn hàng</div>
                                        <div class="kpi-value-main">
                                            <fmt:formatNumber value="${totalRevenue/1000000}" maxFractionDigits="2" />
                                            triệu
                                        </div>
                                        <div class="kpi-growth">
                                            <c:choose>
                                                <c:when test="${revenueGrowth >= 0}">
                                                    <i class="fas fa-arrow-up text-success"></i>
                                                    <fmt:formatNumber value="${revenueGrowth}" maxFractionDigits="0" />%
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="fas fa-arrow-down text-danger"></i>
                                                    <fmt:formatNumber value="${revenueGrowth * -1}"
                                                        maxFractionDigits="0" />%
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-12 col-sm-6 col-lg-3">
                                    <div class="kpi-card kpi-revenue text-center">
                                        <div class="kpi-label">Tiền thực thu</div>
                                        <div class="kpi-value-main">
                                            <fmt:formatNumber value="${actualReceived/1000000}" maxFractionDigits="2" />
                                            triệu
                                        </div>
                                        <div class="kpi-growth" title="Tỷ lệ trên tổng tiền toàn bộ đơn hàng">
                                            <i class="fas fa-percentage text-success"></i>
                                            <fmt:formatNumber value="${receivedRatio}" maxFractionDigits="1" />% tổng
                                        </div>
                                    </div>
                                </div>
                                <div class="col-12 col-sm-6 col-lg-3">
                                    <div class="kpi-card kpi-debt text-center">
                                        <div class="kpi-label">Số còn phải thu</div>
                                        <div class="kpi-value-main">
                                            <fmt:formatNumber value="${receivable/1000000}" maxFractionDigits="2" />
                                            triệu
                                        </div>
                                        <div class="kpi-growth" title="Tỷ lệ nợ trên toàn bộ đơn hàng">
                                            <i class="fas fa-hand-holding-usd text-warning"></i>
                                            <fmt:formatNumber value="${debtRatio}" maxFractionDigits="1" />% nợ
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <!-- Order Status Section -->
                            <div class="section-title">Thống kê đơn hàng</div>
                            <div class="row gap-24">
                                <div class="col-12 col-md-4">
                                    <div class="order-status-card">
                                        <div class="order-status-title">Xử Lý</div>
                                        <div><span class="status-dot dot-yellow"></span> Chờ xử lý:
                                            <b>${statusStats['Pending']}</b>
                                        </div>
                                        <div><span class="status-dot dot-blue"></span> Đã xác nhận:
                                            <b>${statusStats['Confirmed']}</b>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-12 col-md-4">
                                    <div class="order-status-card">
                                        <div class="order-status-title">Vận Chuyển</div>
                                        <div><span class="status-dot dot-blue"></span> Đang giao:
                                            <b>${statusStats['Shipping']}</b>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-12 col-md-4">
                                    <div class="order-status-card">
                                        <div class="order-status-title">Hoàn Tất</div>
                                        <div><span class="status-dot dot-green"></span> Đã giao:
                                            <b>${statusStats['Delivered']}</b>
                                        </div>
                                        <div><span class="status-dot dot-red"></span> Đã hủy:
                                            <b>${statusStats['Cancelled']}</b>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Top Lists Section -->
                            <div class="row gap-24 mt-4">
                                <!-- Top Products -->
                                <div class="col-12 col-xl-6">
                                    <div class="section-title">Top 5 Sản phẩm bán chạy nhất</div>
                                    <div class="table-responsive bg-white rounded shadow-sm p-3 border-0">
                                        <table class="table table-hover align-middle mb-0">
                                            <thead class="table-light">
                                                <tr>
                                                    <th>Tên thuốc</th>
                                                    <th class="text-center">SL bán</th>
                                                    <th class="text-end">Doanh thu</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="p" items="${topProducts}">
                                                    <tr>
                                                        <td class="fw-semibold text-primary">${p.medicineName}</td>
                                                        <td class="text-center">${p.totalQuantity}</td>
                                                        <td class="text-end text-success fw-bold">
                                                            <fmt:formatNumber value="${p.totalRevenue}"
                                                                maxFractionDigits="0" /> ₫
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                                <c:if test="${empty topProducts}">
                                                    <tr>
                                                        <td colspan="3" class="text-center text-muted py-3">Không có số
                                                            liệu</td>
                                                    </tr>
                                                </c:if>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                                <!-- Top Customers -->
                                <div class="col-12 col-xl-6">
                                    <div class="section-title">Top 5 Khách hàng mua nhiều nhất</div>
                                    <div class="table-responsive bg-white rounded shadow-sm p-3 border-0">
                                        <table class="table table-hover align-middle mb-0">
                                            <thead class="table-light">
                                                <tr>
                                                    <th>Khách hàng</th>
                                                    <th class="text-center">Số đơn</th>
                                                    <th class="text-end">Tiền đã mua</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="c" items="${topCustomers}">
                                                    <tr>
                                                        <td class="fw-semibold">${c.customerName} <i
                                                                class="fas fa-crown text-warning ms-1"></i></td>
                                                        <td class="text-center">${c.orderCount}</td>
                                                        <td class="text-end text-success fw-bold">
                                                            <fmt:formatNumber value="${c.totalSpent}"
                                                                maxFractionDigits="0" /> ₫
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                                <c:if test="${empty topCustomers}">
                                                    <tr>
                                                        <td colspan="3" class="text-center text-muted py-3">Không có số
                                                            liệu</td>
                                                    </tr>
                                                </c:if>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                <script src="https://kit.fontawesome.com/4e7e2e6e7b.js" crossorigin="anonymous"></script>
            </body>

            </html>