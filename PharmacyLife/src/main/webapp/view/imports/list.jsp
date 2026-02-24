<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
                <!DOCTYPE html>
                <html>

<<<<<<< HEAD
                <head>
                    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                    <title>Quản lý nhập thuốc - Admin</title>
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/import.css">
=======
            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                <title>Quản lý nhập thuốc</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/import.css">
            </head>
>>>>>>> main

                    <style>
                        body {
                            background-color: #f4f6f9;
                        }

                        .sidebar-wrapper {
                            top: 115px !important;
                            height: calc(100vh - 115px) !important;
                            z-index: 100;
                        }

                        .main-content-dashboard {
                            margin-left: 250px;
                            padding: 30px;
                            margin-top: 115px;
                            max-width: 100%;
                            width: calc(100% - 250px);
                        }

<<<<<<< HEAD
                        .action-bar {
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                            margin-bottom: 25px;
                            flex-wrap: wrap;
                            gap: 15px;
                        }
=======
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
>>>>>>> main

                        .table-container {
                            overflow-x: auto;
                        }

                        .table {
                            min-width: 100%;
                        }

<<<<<<< HEAD
                        .btn-primary-theme {
                            background-color: #4F81E1;
                            color: white;
                            border: none;
                            padding: 10px 24px;
                            border-radius: 8px;
                            text-decoration: none;
                            display: inline-flex;
                            align-items: center;
                            gap: 10px;
                            font-weight: 500;
                            transition: all 0.3s;
                        }

                        .btn-primary-theme:hover {
                            background-color: #3d6cbd;
                            color: white;
                            transform: translateY(-2px);
                            box-shadow: 0 4px 12px rgba(79, 129, 225, 0.3);
                        }

                        .table-container {
                            background: white;
                            padding: 0;
                            border-radius: 12px;
                            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
                            overflow: hidden;
                            border: 1px solid #eef2f7;
                        }

                        .page-title-dashboard {
                            font-size: 28px;
                            font-weight: 700;
                            color: #2c3e50;
                            margin-bottom: 30px;
                            display: flex;
                            align-items: center;
                            gap: 15px;
                        }

                        .status-badge {
                            padding: 6px 14px;
                            border-radius: 20px;
                            font-size: 13px;
                            font-weight: 600;
                        }

                        .status-pending {
                            background-color: #fff3cd;
                            color: #856404;
                        }

                        .status-approved {
                            background-color: #d4edda;
                            color: #155724;
                        }

                        .status-cancelled {
                            background-color: #f8d7da;
                            color: #721c24;
                        }

                        .search-input-group {
                            background: white;
                            border-radius: 8px;
                            padding: 2px;
                            border: 1px solid #dee2e6;
                            width: 400px;
                        }

                        .search-input-group .form-control {
                            border: none;
                            box-shadow: none;
                        }

                        .table>thead {
                            background-color: #f8f9fa;
                        }

                        .table>thead th {
                            font-weight: 600;
                            color: #495057;
                            text-transform: uppercase;
                            font-size: 12px;
                            letter-spacing: 0.5px;
                            padding: 15px;
                            border-bottom: 2px solid #eef2f7;
                        }

                        .table td {
                            padding: 15px;
                            vertical-align: middle;
                        }
                    </style>
                </head>

                <body>
                    <jsp:include page="/view/common/header.jsp" />
                    <jsp:include page="/view/common/sidebar.jsp" />

                    <div class="main-content-dashboard">
                        <div class="page-title-dashboard">
                            <i class="fas fa-file-import" style="color: #4F81E1;"></i>
                            <span>Quản lý nhập thuốc</span>
                        </div>

                        <div class="action-bar">
                            <form method="POST" action="${pageContext.request.contextPath}/import"
                                class="search-input-group d-flex">
                                <input type="hidden" name="action" value="search">
                                <input type="text" name="keyword" class="form-control"
                                    placeholder="Tìm mã phiếu, nhà cung cấp..."
                                    value="${param.keyword != null ? param.keyword : ''}">
                                <button type="submit" class="btn btn-link text-muted">
                                    <i class="fas fa-search"></i>
                                </button>
                            </form>

                            <a href="${pageContext.request.contextPath}/import?action=create"
                                class="btn-primary-theme">
                                <i class="fas fa-plus"></i>
                                <span>Tạo phiếu nhập thuốc</span>
                            </a>
                        </div>

                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show mb-4" role="alert">
                                <i class="fas fa-exclamation-circle me-2"></i>${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"
                                    aria-label="Close"></button>
=======
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
>>>>>>> main
                            </div>
                        </c:if>

                        <div class="table-container">
                            <table class="table table-hover mb-0">
                                <thead>
                                    <tr>
                                        <th class="ps-4">Mã</th>
                                        <th>Nhà cung cấp</th>
                                        <th>Ngày nhập</th>
                                        <th>Tổng tiền</th>
                                        <th>Trạng thái</th>
                                        <th class="text-center">Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty imports}">
                                            <c:forEach var="imp" items="${imports}">
                                                <tr>
                                                    <td class="ps-4 fw-bold text-primary">${imp.importCode}</td>
                                                    <td>${imp.supplierName != null ? imp.supplierName : imp.supplierId}
                                                    </td>
                                                    <td>
                                                        <fmt:formatDate value="${imp.importDate}"
                                                            pattern="dd/MM/yyyy" />
                                                    </td>
                                                    <td class="fw-bold text-success">
                                                        <fmt:formatNumber value="${imp.totalAmount}" type="number"
                                                            groupingUsed="true" maxFractionDigits="0" />₫
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
                                                        <span class="status-badge ${statusClass}">${imp.status != null ?
                                                            imp.status : 'Đang chờ'}</span>
                                                    </td>
                                                    <td class="text-center">
                                                        <div class="d-flex justify-content-center gap-2">
                                                            <a href="${pageContext.request.contextPath}/import?action=view&code=${imp.importCode}"
                                                                class="btn btn-sm btn-outline-info"
                                                                title="Xem chi tiết"><i class="fas fa-eye"></i></a>
                                                            <a href="${pageContext.request.contextPath}/import?action=edit&code=${imp.importCode}"
                                                                class="btn btn-sm btn-outline-warning"
                                                                title="Chỉnh sửa"><i class="fas fa-edit"></i></a>
                                                            <a href="${pageContext.request.contextPath}/import?action=delete&code=${imp.importCode}"
                                                                class="btn btn-sm btn-outline-danger"
                                                                onclick="return confirm('Bạn có chắc chắn muốn xóa phiếu nhập này?')"
                                                                title="Xóa"><i class="fas fa-trash"></i></a>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="6" class="text-center py-5 text-muted">
                                                    <i class="fas fa-box-open fa-3x mb-3 d-block"></i>
                                                    <p>Không có dữ liệu phiếu nhập</p>
                                                </td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
                </body>

                </html>