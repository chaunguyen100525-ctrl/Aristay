# AriStay App - Mô tả Chi tiết Nghiệp vụ Từng Chức năng

## 1. QUẢN LÝ VAI TRÒ & PHÂN QUYỀN

### 1.1 Admin/Manager (Quản trị viên)
**Mô tả:** Vai trò có quyền cao nhất trong hệ thống

**Quyền hạn:**
- Tạo, phân công, cập nhật tất cả các loại task và lịch trình
- Truy cập toàn bộ báo cáo của hệ thống
- Quản lý chat và xử lý sự cố
- Phê duyệt/kiểm tra bằng chứng hoàn thành công việc
- Quản lý nhật ký kiểm kê vật tư

**Thao tác nghiệp vụ:**
1. Đăng nhập hệ thống với quyền Admin
2. Xem dashboard tổng quan tất cả hoạt động
3. Tạo/chỉnh sửa lịch làm việc cho các team
4. Phân công task cho từng nhân viên
5. Theo dõi tiến độ thực hiện qua báo cáo real-time
6. Xử lý cảnh báo và sự cố khẩn cấp
7. Kiểm tra và phê duyệt ảnh chụp bằng chứng
8. Export báo cáo định kỳ

### 1.2 Cleaning Staff (Nhân viên vệ sinh)
**Mô tả:** Nhân viên thực hiện công việc dọn dẹp phòng

**Quyền hạn:**
- Chỉ xem các task được phân công
- Hoàn thành checklist phòng
- Upload ảnh trước/sau khi dọn
- Báo cáo thiếu hụt/hư hỏng vật tư
- Ghi nhận đồ thất lạc

**Thao tác nghiệp vụ:**
1. Đăng nhập app và xem To-Do list hàng ngày
2. Nhận push notification về task mới
3. Check-in khi bắt đầu làm việc (GPS + timestamp)
4. Chụp ảnh "Before" trước khi dọn phòng
5. Thực hiện dọn phòng theo checklist từng bước:
   - Phòng ngủ: dọn giường, thay ga, hút bụi, lau bụi
   - Phòng tắm: vệ sinh toilet, bồn rửa, gương, sàn
   - Phòng khách: sắp xếp đồ đạc, hút bụi, lau bụi
   - Bếp: rửa bát, lau mặt bếp, tủ lạnh, sàn
6. Đánh dấu hoàn thành từng bước trong checklist
7. Nếu phát hiện hư hỏng: chụp ảnh + ghi chú chi tiết
8. Nếu thiếu vật tư: báo cáo shortage → tự động tạo task cho Maintenance
9. Nếu tìm thấy đồ thất lạc: chụp ảnh + ghi nhận vào Lost & Found log
10. Chụp ảnh "After" sau khi hoàn thành
11. Check-out và submit task
12. Hệ thống AI kiểm tra ảnh và cảnh báo nếu còn sót

### 1.3 Maintenance Staff (Nhân viên bảo trì)
**Mô tả:** Nhân viên phụ trách sửa chữa và bổ sung vật tư

**Quyền hạn:**
- Xem task bảo trì được phân công
- Xem task kiểm kê và bổ sung vật tư
- Cập nhật trạng thái công việc
- Upload ảnh và ghi chú
- Ghi nhận việc sử dụng/bổ sung vật tư

**Thao tác nghiệp vụ:**

**A. Xử lý task bảo trì:**
1. Xem danh sách task trên calendar (màu sắc phân biệt mức độ ưu tiên)
2. Nhận task hoặc claim task mở
3. Check-in khi bắt đầu
4. Chụp ảnh "Before" (tình trạng hư hỏng)
5. Thực hiện sửa chữa/bảo trì
6. Chụp ảnh "After" (đã khắc phục)
7. Ghi chú chi tiết công việc đã làm
8. Đánh dấu hoàn thành

**B. Xử lý task kiểm kê vật tư:**
1. Nhận thông báo shortage từ Cleaning staff
2. Kiểm tra inventory hiện tại của property
3. Chuẩn bị vật tư cần bổ sung theo par level
4. Check-in tại property
5. Thực hiện restock:
   - Đếm số lượng vật tư bổ sung
   - Chụp ảnh vật tư đã bổ sung
   - Ghi nhận vào hệ thống (Stock-in log)
6. Cập nhật số lượng tồn kho mới
7. Submit task hoàn thành

### 1.4 Laundry Staff (Nhân viên giặt là)
**Mô tả:** Nhân viên phụ trách giặt là và quản lý vải vóc

**Quyền hạn:**
- Xem task giặt là được phân công
- Ghi nhận số lượng vải vóc
- Báo cáo thiếu hụt hoặc hư hỏng
- Upload ảnh bằng chứng

**Thao tác nghiệp vụ:**

**A. Pick-up (Thu gom):**
1. Nhận task pick-up
2. Check-in tại property
3. Đếm và ghi nhận số lượng từng loại:
   - Ga giường: số lượng, kích cỡ
   - Khăn tắm: số lượng, loại
   - Khăn mặt, khăn nhỏ
   - Chăn, gối
4. Kiểm tra tình trạng (có vết bẩn khó giặt, rách, hỏng)
5. Chụp ảnh bằng chứng
6. Check-out và vận chuyển

**B. Wash/Dry (Giặt/Sấy):**
1. Nhận task giặt
2. Phân loại vải theo màu sắc và chất liệu
3. Thực hiện giặt theo quy trình
4. Kiểm tra sau giặt, xử lý vết bẩn còn sót
5. Sấy khô và gấp gọn
6. Đánh dấu hoàn thành từng batch

**C. Drop-off & Restock (Giao trả và bổ sung):**
1. Nhận task drop-off
2. Chuẩn bị vải sạch theo số lượng yêu cầu
3. Check-in tại property
4. Đếm và ghi nhận số lượng giao trả
5. So sánh với số lượng pick-up ban đầu
6. Nếu thiếu: ghi nhận shortage
7. Nếu hỏng: ghi nhận damaged linen
8. Chụp ảnh vải đã sắp xếp gọn gàng
9. Cập nhật vào Inventory module
10. Check-out và submit

### 1.5 Lawn/Pool Vendors (Nhà thầu chăm sóc sân vườn/bể bơi)
**Mô tả:** Đối tác bên ngoài thực hiện công việc chuyên môn

**Quyền hạn:**
- Chỉ xem task được phân công
- Submit bằng chứng hoàn thành
- GPS check-in/out

**Thao tác nghiệp vụ:**

**A. Lawn Care (Chăm sóc sân cỏ):**
1. Nhận task recurring hoặc one-time
2. Xem thông tin property: diện tích, loại cỏ, ghi chú đặc biệt
3. Check-in bằng GPS khi đến property
4. Chụp ảnh "Before"
5. Thực hiện công việc:
   - Mowing (cắt cỏ)
   - Edging (tỉa cạnh)
   - Fertilization (bón phân)
   - Weeding (nhổ cỏ dại)
6. Chụp ảnh "After"
7. GPS check-out khi hoàn thành
8. Submit task

**B. Pool Care (Chăm sóc bể bơi):**
1. Nhận task theo lịch định kỳ
2. Xem profile bể bơi: loại, kích thước, thiết bị
3. Check-in GPS
4. Chụp ảnh "Before" (tình trạng nước, bề mặt)
5. Thực hiện:
   - Vớt rác, lá cây
   - Chà rửa thành bể
   - Kiểm tra và điều chỉnh hóa chất (pH, chlorine)
   - Kiểm tra máy lọc, bơm
6. Ghi nhận số liệu hóa chất
7. Chụp ảnh "After"
8. GPS check-out
9. Submit task với các số liệu đo được

---

## 2. CÁC MODULE CHỨC NĂNG CHI TIẾT

### Module A: QUẢN LÝ LỊCH VỆ SINH (Cleaning Schedule Management)

#### A.1 Import Schedule (Nhập lịch)
**Người thực hiện:** Admin

**Quy trình:**
1. Admin vào menu "Cleaning Schedule"
2. Chọn "Import Schedule"
3. Upload file CSV/Excel chứa thông tin:
   - Property ID/Name
   - Check-in date & time
   - Check-out date & time
   - Room type
   - Guest count
   - Special requirements
4. Hệ thống validate dữ liệu
5. Xác nhận import
6. Hệ thống tự động tạo cleaning task dựa trên:
   - Check-out date (dọn sau khi khách rời)
   - Check-in date (chuẩn bị trước khi khách đến)
7. Task được phân công tự động hoặc thủ công

#### A.2 Calendar View (Xem lịch)
**Người thực hiện:** Admin, Cleaning Staff

**Giao diện:**
- View theo: Day / Week / Month
- Màu sắc phân biệt:
  - Xanh: Pending
  - Vàng: In Progress
  - Xanh lá: Completed
  - Đỏ: Overdue/Issue
- Filter theo: Property, Staff, Status

**Thao tác:**
- Click vào task để xem chi tiết
- Drag & drop để reschedule (chỉ Admin)
- Click "Assign" để phân công lại

#### A.3 Daily To-Do List (Danh sách công việc hàng ngày)
**Người thực hiện:** Cleaning Staff

**Quy trình:**
1. Staff mở app vào đầu ngày
2. Xem danh sách task được phân công:
   - Thời gian deadline
   - Địa chỉ property
   - Loại công việc (Check-out clean / Check-in prep)
   - Ưu tiên (High/Medium/Low)
3. Nhận push notification khi có task mới
4. Click vào task để bắt đầu làm việc
5. Task được sắp xếp theo:
   - Thời gian deadline (gần nhất trước)
   - Mức độ ưu tiên
   - Khoảng cách địa lý (gần nhất trước)

#### A.4 Room-by-Room Checklist (Danh mục kiểm tra từng phòng)
**Người thực hiện:** Cleaning Staff

**Cấu trúc checklist:**

**Living Room (Phòng khách):**
- [ ] Hút bụi sàn nhà
- [ ] Lau bụi bề mặt (bàn, kệ, TV)
- [ ] Sắp xếp gối, đệm trên sofa
- [ ] Kiểm tra remote điều khiển (pin, vệ sinh)
- [ ] Vệ sinh cửa sổ, gương
- [ ] Đổ rác
- [ ] Kiểm tra đèn, thiết bị điện

**Bedroom (Phòng ngủ):**
- [ ] Thay ga giường, vỏ gối, chăn
- [ ] Sắp xếp gối và đệm gọn gàng
- [ ] Hút bụi sàn và dưới giường
- [ ] Lau bụi tủ, bàn đầu giường
- [ ] Vệ sinh gương, cửa sổ
- [ ] Kiểm tra tủ quần áo (trống, sạch)
- [ ] Đổ rác

**Bathroom (Phòng tắm):**
- [ ] Vệ sinh toilet (bên trong & bên ngoài)
- [ ] Vệ sinh bồn rửa mặt
- [ ] Vệ sinh bồn tắm/shower
- [ ] Lau gương và vòi nước (không vết nước)
- [ ] Lau sàn và tường
- [ ] Bổ sung vật tư: toilet paper, soap, shampoo
- [ ] Thay khăn tắm, thảm chân
- [ ] Đổ rác
- [ ] Kiểm tra thoát nước

**Kitchen (Bếp):**
- [ ] Rửa bát đĩa, dụng cụ nấu ăn
- [ ] Vệ sinh bề mặt bếp, lò nướng
- [ ] Lau tủ lạnh (bên trong & bên ngoài)
- [ ] Vệ sinh bồn rửa
- [ ] Lau bàn ăn, ghế
- [ ] Lau sàn bếp
- [ ] Đổ rác
- [ ] Kiểm tra thiết bị: máy rửa chén, lò vi sóng

**Blocking Steps (Bước bắt buộc):**
- Một số bước quan trọng phải hoàn thành mới được chuyển sang bước tiếp theo
- Ví dụ: Phải chụp ảnh "Before" mới mở được checklist
- Phải hoàn thành checklist bathroom mới được đánh dấu bedroom xong

#### A.5 Damage/Loss Report (Báo cáo hư hỏng/thất lạc)
**Người thực hiện:** Cleaning Staff

**Quy trình:**
1. Trong quá trình dọn, phát hiện hư hỏng
2. Click button "Report Damage/Loss"
3. Chọn loại:
   - Damage (Hư hỏng)
   - Missing Item (Mất đồ)
   - Malfunction (Hỏng hóc thiết bị)
4. Chọn vị trí: Living Room / Bedroom / Bathroom / Kitchen
5. Chụp ảnh chi tiết (tối thiểu 2 ảnh)
6. Mô tả bằng văn bản:
   - Vật phẩm/thiết bị bị ảnh hưởng
   - Mức độ hư hỏng
   - Nguyên nhân (nếu biết)
7. Đánh giá mức độ: Low / Medium / High / Urgent
8. Submit report
9. Hệ thống tự động:
   - Gửi notification cho Admin
   - Tạo maintenance task (nếu cần sửa chữa)
   - Ghi nhận vào property history

#### A.6 Lost & Found Log (Nhật ký đồ thất lạc)
**Người thực hiện:** Cleaning Staff

**Quy trình:**
1. Tìm thấy đồ khách để quên
2. Click "Log Lost & Found"
3. Chụp ảnh vật phẩm (nhiều góc độ)
4. Điền thông tin:
   - Property name
   - Room location
   - Item description (mô tả chi tiết)
   - Quantity
   - Condition (tình trạng)
   - Found date & time (tự động)
5. Submit log
6. Admin nhận thông báo
7. Admin liên hệ khách để hoàn trả
8. Khi hoàn trả: Admin cập nhật status "Returned" + ghi chú

**Quản lý Lost & Found:**
- Admin xem danh sách tất cả lost items
- Filter theo: Date, Property, Status
- Status: Found → Contacted → Returned / Disposed
- Tự động nhắc nhở sau 30 ngày nếu chưa claim

#### A.7 Proof of Work (Bằng chứng hoàn thành)
**Người thực hiện:** Cleaning Staff

**Yêu cầu bắt buộc:**
1. **Before Photos (Ảnh trước khi dọn):**
   - Chụp tổng quan mỗi phòng
   - Tối thiểu: Living room, Bedroom(s), Bathroom(s), Kitchen
   - Chụp rõ các khu vực còn bẩn/bừa bộn

2. **After Photos (Ảnh sau khi dọn):**
   - Chụp cùng góc độ với Before photos
   - Thể hiện rõ sự thay đổi
   - Tất cả khu vực phải sạch sẽ, ngăn nắp

3. **GPS & Timestamp:**
   - Tự động ghi nhận khi check-in/check-out
   - Đảm bảo staff có mặt tại property
   - Tính toán thời gian làm việc thực tế

4. **AI Quality Check:**
   - Hệ thống AI phân tích ảnh After
   - Phát hiện:
     - Vết bẩn còn sót
     - Đồ đạc chưa sắp xếp gọn
     - Bụi, cặn còn lại
     - Vết nước trên gương, vòi
   - Tạo alert cho Admin nếu phát hiện vấn đề
   - Staff phải chụp lại/sửa chữa

**Không thể submit task nếu thiếu:**
- Ảnh Before/After
- GPS check-in/check-out
- Checklist chưa hoàn thành 100%

---

### Module B: QUẢN LÝ CÔNG VIỆC BỔ SUNG (To-Do Management)

#### B.1 Tạo Task Bổ Sung
**Người thực hiện:** Admin

**Quy trình:**
1. Admin vào "Create New Task"
2. Điền thông tin:
   - Task type: Cleaning / Maintenance / Inspection / Other
   - Property
   - Assigned to: Chọn staff hoặc để "Open to claim"
   - Priority: Low / Medium / High / Urgent
   - Due date & time
   - Task description
   - Checklist items (nếu cần)
   - Attach files/photos (nếu cần)
3. Preview task
4. Click "Create & Assign"
5. Hệ thống:
   - Gửi push notification cho staff được assign
   - Thêm vào To-Do list của staff
   - Đánh dấu trên calendar

#### B.2 Auto-Update To-Do List
**Người thực hiện:** Hệ thống tự động

**Kích hoạt khi:**
- Admin tạo task mới → Thêm vào To-Do list
- Schedule import → Tạo cleaning tasks
- Shortage report → Tạo inventory task cho Maintenance
- Damage report → Tạo maintenance task
- Task được reassign → Di chuyển giữa các To-Do list

**Notification gửi đến staff:**
- "🔔 New task assigned: [Task name] at [Property]"
- "⏰ Reminder: [Task name] due in 2 hours"
- "🚨 Urgent task: [Task name] requires immediate attention"

#### B.3 Task Status Flow
**Quy trình trạng thái:**

```
PENDING → IN PROGRESS → COMPLETED
   ↓           ↓              ↓
CANCELLED  BLOCKED      VERIFIED (by Admin)
```

**Pending (Chờ xử lý):**
- Task mới tạo, chưa bắt đầu
- Staff xem được nhưng chưa nhận
- Màu: Xám

**In Progress (Đang thực hiện):**
- Staff click "Start Task"
- Check-in GPS
- Đang làm việc
- Màu: Vàng

**Blocked (Bị chặn):**
- Staff báo cáo không thể hoàn thành do:
  - Thiếu vật tư
  - Không vào được property
  - Cần hỗ trợ kỹ thuật
- Phải ghi chú lý do
- Admin xử lý và unblock
- Màu: Cam

**Completed (Hoàn thành):**
- Staff hoàn thành checklist
- Upload proof of work
- Submit task
- Chờ Admin verify
- Màu: Xanh lá nhạt

**Verified (Đã xác nhận):**
- Admin kiểm tra và approve
- Task được đóng
- Màu: Xanh lá đậm

**Cancelled (Hủy bỏ):**
- Admin hủy task do:
  - Guest cancel booking
  - Lịch thay đổi
  - Task trùng lặp
- Phải ghi chú lý do
- Màu: Đỏ gạch ngang

---

### Module C: GIAO TIẾP & XỬ LÝ SỰ CỐ (Communication & Incident Handling)

#### C.1 In-App Chat
**Người dùng:** Admin ↔ All Staff

**Cấu trúc:**
- Chat threads được nhóm theo Property
- Mỗi task có thể có chat thread riêng
- Group chat cho từng team (Cleaning / Maintenance / Laundry)
- Direct message 1-1

**Tính năng:**
1. **Gửi tin nhắn văn bản:**
   - Typing indicator (đang gõ...)
   - Read receipts (đã đọc)
   - Timestamp cho mỗi tin nhắn

2. **Gửi media:**
   - Photos: Chụp trực tiếp hoặc upload từ thư viện
   - Videos: Quay video hoặc upload (max 2 phút)
   - Compression tự động để tiết kiệm bandwidth

3. **Voice notes:** (Optional)
   - Ghi âm voice message
   - Max 60 giây

4. **Quick replies:**
   - "On my way" (Đang trên đường)
   - "Completed" (Đã xong)
   - "Need help" (Cần hỗ trợ)
   - "Will be late" (Sẽ trễ)

5. **Mentions:**
   - @Admin để tag admin
   - @Staff_name để tag người cụ thể

#### C.2 Urgent Alerts (Cảnh báo khẩn cấp)
**Người thực hiện:** All Staff → Admin

**Khi nào sử dụng:**
- Hư hỏng nghiêm trọng (broken pipe, flood, fire hazard)
- Không vào được property (khóa hỏng, guest chưa check-out)
- Phát hiện vấn đề an ninh
- Tai nạn lao động
- Thiếu vật tư nghiêm trọng ảnh hưởng đến check-in

**Quy trình:**
1. Staff click nút "🚨 URGENT ALERT"
2. Chọn loại alert:
   - Emergency (Khẩn cấp)
   - Property Access Issue
   - Safety Hazard
   - Equipment Failure
   - Other
3. Chụp ảnh/quay video hiện trường
4. Ghi chú mô tả ngắn gọn
5. Submit alert
6. Hệ thống:
   - Gửi push notification + SMS cho Admin ngay lập tức
   - Highlight màu đỏ trên dashboard
   - Tạo incident ticket tự động
   - Admin phải acknowledge trong 15 phút

#### C.3 Incident Ticket Management
**Người thực hiện:** Admin

**Quy trình xử lý:**
1. Admin nhận urgent alert
2. Click "Acknowledge" để xác nhận đã nhận
3. Xem chi tiết: Photos, location, staff report
4. Đánh giá mức độ nghiêm trọng:
   - P0: Critical (xử lý ngay trong 1h)
   - P1: High (xử lý trong 4h)
   - P2: Medium (xử lý trong 24h)
   - P3: Low (xử lý trong 3 ngày)
5. Phân công:
   - Assign cho Maintenance team
   - Hoặc liên hệ vendor bên ngoài
   - Hoặc xử lý trực tiếp
6. Theo dõi tiến độ qua chat thread
7. Yêu cầu photo/video bằng chứng đã khắc phục
8. Close ticket khi hoàn tất
9. Ghi nhận vào incident log

**Incident Log:**
- Lưu trữ tất cả incidents theo property
- Filter theo: Date, Type, Severity, Status
- Export để báo cáo cho property owner
- Phân tích xu hướng để phòng ngừa

---

### Module D: KIỂM TRA CHẤT LƯỢNG BẰNG HÌNH ẢNH (Image Upload & Quality Assurance)

#### D.1 Yêu Cầu Upload Ảnh
**Tính năng tự động:**
- Metadata: GPS coordinates, timestamp, device info
- Compression: Giảm dung lượng nhưng giữ chất lượng
- Watermark: Tên staff, property, date/time (optional)

**Quy định:**
- Before photos: Bắt buộc trước khi bắt đầu làm việc
- After photos: Bắt buộc sau khi hoàn thành
- Minimum: 1 ảnh mỗi phòng
- Recommended: 2-3 ảnh mỗi phòng (different angles)
- Format: JPG, PNG
- Max size: 10MB/ảnh
- Upload khi có internet (auto-queue nếu offline)

#### D.2 AI Quality Detection
**Công nghệ:** Computer Vision AI

**Phát hiện các vấn đề:**

1. **Vết bẩn (Stains):**
   - Vết cà phê, rượu trên thảm
   - Vết bẩn trên ga giường
   - Vết nước, xà phòng trên gương/kính

2. **Cặn, bụi (Residue, Dust):**
   - Bụi trên bề mặt bàn, kệ
   - Vết nước khô trên vòi nước
   - Cặn xà phòng trong phòng tắm

3. **Đồ đạc lộn xộn (Clutter):**
   - Gối không được xếp gọn
   - Đồ vật không đúng vị trí
   - Rác chưa được đổ

4. **Thiết bị chưa vệ sinh:**
   - Remote control bẩn
   - Công tắc đèn có dấu vân tay
   - Tay nắm cửa chưa lau

**Quy trình:**
1. Staff upload ảnh After
2. AI xử lý trong 10-30 giây
3. Nếu phát hiện vấn đề:
   - Highlight vùng có vấn đề trên ảnh
   - Gửi alert cho Staff
   - "⚠️ Quality issue detected in [Room]: [Issue type]"
4. Staff có 2 lựa chọn:
   - **Re-clean:** Quay lại làm lại và chụp ảnh mới
   - **Explain:** Giải thích (ví dụ: vết cũ không thể làm sạch, cần chuyên gia)
5. Admin nhận notification để review
6. Admin quyết định: Accept / Request re-clean / Create maintenance task

#### D.3 Quality Report Storage
**Lưu trữ và quản lý:**

**Cấu trúc dữ liệu:**
- Property ID
- Cleaning date
- Staff assigned
- Before/After photos (URLs)
- AI scan results
- Quality score (0-100)
- Issues detected
- Resolution status
- Admin notes

**Dashboard Admin:**
- Xem quality trends theo:
  - Staff performance (% passed AI check)
  - Property-specific issues
  - Common problems
- Compare staff efficiency
- Identify training needs

**Reports:**
- Daily quality summary
- Weekly staff performance report
- Property-specific quality history
- Export for property owner review

---

### Module E: QUẢN LÝ LỊCH BẢO TRÌ (Maintenance Schedule Management)

#### E.1 Tạo và Cập Nhật Task Bảo Trì
**Người thực hiện:** Admin

**Loại task:**
1. **Preventive Maintenance (Bảo trì định kỳ):**
   - AC filter replacement (3 tháng)
   - HVAC inspection (6 tháng)
   - Smoke detector test (6 tháng)
   - Water heater flush (1 năm)
   - Roof inspection (1 năm)

2. **Corrective Maintenance (Sửa chữa):**
   - Từ damage reports của Cleaning staff
   - Từ incident tickets
   - Từ guest complaints

3. **Emergency Maintenance (Khẩn cấp):**
   - Broken pipe, leak
   - Power outage
   - HVAC failure
   - Lock malfunction

**Quy trình tạo task:**
1. Admin vào "Maintenance Schedule"
2. Click "Create Task"
3. Điền thông tin:
   - **Property:** Chọn từ dropdown
   - **Category:** Plumbing / Electrical / HVAC / Appliance / Structural / Other
   - **Priority:** Low / Medium / High / Emergency
   - **Task title:** Mô tả ngắn gọn
   - **Description:** Chi tiết vấn đề
   - **Due date:** Deadline hoàn thành
   - **Estimated time:** Thời gian dự kiến (hours)
   - **Required skills:** Chọn kỹ năng cần thiết
   - **Attach files:** Photos, documents
4. **Assignment options:**
   - Assign to specific staff
   - Leave open to claim (staff tự nhận)
   - Assign to external vendor
5. **Color coding:**
   - 🔴 Red: Emergency (P0)
   - 🟠 Orange: High priority (P1)
   - 🟡 Yellow: Medium priority (P2)
   - 🟢 Green: Low priority (P3)
6. Click "Create"
7. Notification gửi đến staff/vendor

#### E.2 Unified Calendar View
**Tính năng:**

**Hiển thị tất cả tasks:**
- Cleaning tasks (màu xanh dương)
- Maintenance tasks (màu cam)
- Laundry tasks (màu tím)
- Lawn/Pool tasks (màu xanh lá)
- Inventory tasks (màu vàng)

**Views:**
- **Day view:** Timeline từ 6AM - 10PM
- **Week view:** 7 ngày, grid layout
- **Month view:** Calendar tháng
- **List view:** Danh sách theo thứ tự thời gian

**Filters:**
- By property
- By staff/team
- By task type
- By status
- By priority

**Interactions:**
- Click vào task → Xem chi tiết
- Hover → Quick preview
- Drag & drop → Reschedule (Admin only)
- Right-click → Quick actions (Assign, Delete, Duplicate)

**Resource management:**
- Hiển thị workload của từng staff
- Cảnh báo overload (quá nhiều task/ngày)
- Đề xuất phân công hợp lý
- Tính toán travel time giữa các properties

#### E.3 Task Assignment & Claiming
**Hai phương thức:**

**A. Admin Assign (Phân công trực tiếp):**
1. Admin chọn task
2. Click "Assign to"
3. Chọn staff từ danh sách available
4. Xác nhận
5. Staff nhận notification

**B. Open to Claim (Mở cho nhận việc):**
1. Admin tạo task không assign
2. Task hiển thị trong "Available Tasks" pool
3. Maintenance staff xem danh sách
4. Filter theo: Location, Skills required, Time
5. Click "Claim Task"
6. Confirm
7. Task chuyển vào To-Do list của staff
8. Notification cho Admin

**Rules:**
- Staff chỉ claim được task phù hợp với skills
- Không claim quá 5 tasks cùng lúc
- Phải estimate completion time khi claim
- Admin có thể reassign nếu cần

#### E.4 Notifications & Reminders
**Tự động gửi:**

**24 hours before:**
- "📅 Reminder: [Task name] at [Property] due tomorrow"
- Bao gồm: Address, task details, checklist

**2 hours before:**
- "⏰ Upcoming task: [Task name] starts in 2 hours"
- "📍 Location: [Address] - [Map link]"

**When overdue:**
- "🚨 Overdue: [Task name] was due at [Time]"
- Gửi mỗi 2 giờ cho đến khi complete
- Admin nhận escalation notification

**When reassigned:**
- "🔄 Task reassigned: [Task name] from [Old staff] to [New staff]"

**Status changes:**
- Staff → Admin: "Task [Name] marked as Completed"
- Admin → Staff: "Task [Name] verified and approved"

#### E.5 Status Tracking
**Workflow:**

```
ASSIGNED → IN PROGRESS → COMPLETED → VERIFIED
   ↓            ↓             ↓
CLAIMED      PAUSED      REJECTED (need rework)
                ↓
            BLOCKED
```

**Status details:**

**Assigned:** Task được giao nhưng chưa bắt đầu
**Claimed:** Staff tự nhận task
**In Progress:** Đang thực hiện
**Paused:** Tạm dừng (thiếu parts, chờ approval)
**Blocked:** Bị chặn (external dependencies)
**Completed:** Staff hoàn thành, chờ verify
**Verified:** Admin xác nhận OK
**Rejected:** Admin yêu cầu làm lại

**Mỗi status change phải có:**
- Timestamp
- User who changed
- Notes/reason

#### E.6 Weekly/Monthly Maintenance Reports
**Auto-generate báo cáo:**

**Weekly Report (Mỗi thứ Hai):**
- Total tasks created/completed
- Tasks by category breakdown
- Staff performance (completion rate, avg time)
- Overdue tasks
- Recurring issues
- Top 5 properties needing attention
- Cost estimate (labor + parts)

**Monthly Report:**
- All above metrics aggregated
- Month-over-month trends
- Property maintenance history
- Preventive maintenance compliance
- Vendor performance (nếu có)
- Budget vs actual spend
- Recommendations for next month

**Export formats:**
- PDF (formatted, ready to send)
- CSV (raw data for analysis)
- Email directly to property owners

---

### Module F: QUẢN LÝ KIỂM KÊ VẬT TƯ (Supplies Inventory Management)

#### F.1 Property Inventory Profiles
**Thiết lập cho mỗi property:**

**Consumables tracking:**

**Bathroom supplies:**
- Toilet paper (rolls)
- Hand soap (bottles)
- Shampoo (bottles)
- Conditioner (bottles)
- Body wash (bottles)
- Facial tissue (boxes)
- Trash bags (small)

**Kitchen supplies:**
- Dish soap (bottles)
- Sponges (count)
- Trash bags (large)
- Paper towels (rolls)
- Coffee filters (count)
- Dishwasher pods (count)

**Cleaning supplies:**
- All-purpose cleaner (bottles)
- Glass cleaner (bottles)
- Disinfectant (bottles)
- Toilet bowl cleaner (bottles)
- Floor cleaner (bottles)

**Maintenance items:**
- Light bulbs (by type: LED, standard)
- Batteries (AA, AAA, 9V)
- AC filters (by size)
- Furnace filters
- Smoke detector batteries

**Pool chemicals (nếu có):**
- Chlorine tablets (lbs)
- pH increaser (lbs)
- pH decreaser (lbs)
- Algaecide (bottles)
- Pool shock (lbs)

**Par Levels (Mức tồn kho chuẩn):**
- Minimum level (cảnh báo khi dưới mức này)
- Target level (mức nên duy trì)
- Maximum level (không vượt quá)

**Setup process:**
1. Admin vào "Inventory" → "Property Profiles"
2. Select property
3. Click "Setup Inventory"
4. Chọn categories cần track
5. Đặt par levels cho từng item
6. Save profile
7. Thực hiện initial count

#### F.2 Stock-in / Stock-out Logging
**Stock-in (Nhập kho):**

**Quy trình:**
1. Maintenance staff nhận task restock
2. Check-in tại property
3. Vào "Inventory" → "Stock-in"
4. Chọn property
5. Scan barcode hoặc chọn items từ list:
   - Item name
   - Quantity added
   - Unit (rolls, bottles, boxes)
   - Expiry date (if applicable)
6. Chụp ảnh các items đã restock
7. Ghi chú vị trí lưu trữ
8. Submit
9. Hệ thống cập nhật:
   - Current stock level
   - Last restock date
   - Next restock estimate

**Stock-out (Xuất kho/Sử dụng):**

**Tự động ghi nhận:**
- Cleaning staff complete checklist → Hệ thống tự động trừ items thông dụng
- Ví dụ: Complete bathroom cleaning → Tự động trừ 1 set of towels usage

**Thủ công ghi nhận:**
1. Staff vào "Inventory" → "Stock-out"
2. Chọn property
3. Select items used:
   - Item name
   - Quantity used
   - Reason (Cleaning / Guest use / Damaged)
4. Submit
5. System updates stock level

#### F.3 Shortage Alerts
**Auto-detection:**

**Khi Cleaning staff báo cáo shortage:**
1. Trong checklist, tick "Out of stock" cho item
2. Upload photo (empty shelf/cabinet)
3. Submit
4. Hệ thống:
   - Cập nhật stock level về 0
   - Tạo "🚨 SHORTAGE ALERT" cho Admin
   - Tự động tạo restock task cho Maintenance
   - Email Admin nếu urgent item

**Khi stock level < minimum par:**
1. Hệ thống check stock levels mỗi ngày
2. Nếu phát hiện below minimum:
   - "⚠️ Low Stock Alert: [Item] at [Property]"
   - Current: 2, Minimum: 5, Target: 10
3. Gửi notification cho Admin và Maintenance team
4. Highlight màu vàng trên dashboard
5. Tự động tạo restock task (Priority: Medium)

**Urgent shortages:**
- Items quan trọng: Toilet paper, towels, AC filters
- Nếu = 0: Priority escalate to HIGH
- Notification gửi đến cả Admin và Maintenance lead
- SMS alert (optional)

#### F.4 Proof & Audit
**Photo requirements:**
- Before restock: Chụp khu vực trống/thiếu
- After restock: Chụp items đã bổ sung, gọn gàng
- Expiry dates: Chụp rõ ngày hết hạn nếu có

**Audit trail:**
Mỗi transaction ghi nhận:
- Transaction ID
- Date & timestamp
- Property
- Staff member
- Action (Stock-in / Stock-out)
- Items & quantities
- Photos (URLs)
- GPS location
- Before/after stock levels
- Notes

**Historical log view:**
- Filter by: Date range, Property, Staff, Item
- Export to CSV
- Compare periods
- Identify patterns (high usage properties)

**Reconciliation:**
- Monthly physical count
- Compare system vs actual
- Investigate discrepancies
- Adjust system counts
- Note reasons for variances

#### F.5 Inventory Reporting
**Weekly Report:**
- Stock levels all properties (summary table)
- Items below par (alert list)
- Restocks completed this week
- Top 5 most-used items
- Properties needing attention
- Estimated restock cost

**Monthly Report:**
- Total items used by category
- Cost analysis (quantity × unit price)
- Usage trends (compare to previous month)
- Waste/damage reports
- Inventory turnover rate
- Budget forecast for next month
- Property comparison (usage per property type)

**Custom Reports:**
- Filter by: Date range, Property, Category, Staff
- Metrics:
  - Usage rate per day
  - Cost per property per month
  - Restocking frequency
  - Shortage incidents
- Visualizations:
  - Bar charts (usage by category)
  - Line graphs (trends over time)
  - Pie charts (cost breakdown)
- Export to:
  - PDF (formatted with charts)
  - CSV (raw data)
  - Excel (with pivot tables)

**Owner Reports:**
- Monthly inventory costs per property
- Comparison to other similar properties
- Recommendations to optimize
- Photos of well-stocked properties

---

### Module G: QUẢN LÝ GIẶT LÀ (Laundry Management)

#### G.1 Task Types
**Bốn loại task chính:**

**1. Pick-up (Thu gom đồ giặt):**
- Collect dirty linens from property
- Count and document items
- Check condition
- Transport to laundry facility

**2. Wash/Dry (Giặt và sấy):**
- Process linens at facility
- Sort by color and fabric
- Wash, dry, fold
- Quality check

**3. Drop-off (Giao trả đồ sạch):**
- Deliver clean linens to property
- Verify quantities match pick-up
- Place in designated storage

**4. Restock (Bổ sung linen):**
- Check linen inventory at property
- Replenish to par levels
- Update inventory system

#### G.2 Linen Checklist
**Count In/Out tracking:**

**Setup:**
Mỗi property có linen profile:
- Bed sheets: Twin (X), Full (X), Queen (X), King (X)
- Pillowcases: Standard (X), King (X)
- Duvet covers: sizes and quantities
- Blankets: types and quantities
- Bath towels: (X)
- Hand towels: (X)
- Washcloths: (X)
- Bath mats: (X)
- Kitchen towels: (X)

**Pick-up checklist:**
1. Staff arrives at property
2. Check-in GPS
3. Open "Laundry" → "Pick-up"
4. Select property
5. Count each linen type:
   - Use counter interface (tap +/- buttons)
   - System shows expected count from last drop-off
   - Note discrepancies
6. Inspect condition cho mỗi item:
   - ✅ Good: Clean, no damage
   - ⚠️ Stained: Has stains but usable
   - ❌ Damaged: Torn, holes, need replacement
7. For damaged items:
   - Mark quantity damaged
   - Chụp ảnh chi tiết
   - Note type of damage
8. Take photo of collected laundry bag
9. Submit pick-up
10. System generates pick-up receipt with:
    - Items collected
    - Condition summary
    - Photos
    - Timestamp & GPS

**Drop-off checklist:**
1. Staff arrives with clean linens
2. Check-in GPS
3. Open "Laundry" → "Drop-off"
4. Select property
5. Verify counts match pick-up:
   - System shows expected quantities
   - Count actual delivery
   - Flag if mismatch
6. If shortage:
   - Enter short quantity
   - Select reason:
     - Still in process
     - Damaged and discarded
     - Lost in process
   - Note when will deliver
7. Take photo of delivered linens
8. Arrange linens in storage:
   - Folded neatly
   - Organized by type
   - Easy to access
9. Take photo of organized storage
10. Submit drop-off
11. System updates property linen inventory

#### G.3 Shortage & Damage Logging
**Shortage scenarios:**

**During pick-up - Missing items:**
1. Count shows fewer items than expected
2. Mark shortage in system
3. Search property thoroughly
4. If not found:
   - Take photo of count
   - Note "Missing: [X] bath towels"
   - System alerts Admin
5. Admin investigates:
   - Check previous cleaning reports
   - Review guest checkout notes
   - Determine if guest took items
6. Create restock task to replenish

**During wash - Items damaged in process:**
1. Notice damage during washing/folding
2. Set aside damaged items
3. Log in system:
   - Item type & quantity
   - Type of damage (tear, shrink, discolor)
   - Photo evidence
   - Estimated cause
4. Damaged items disposed or sent for repair
5. System updates inventory
6. Auto-create restock task

**At drop-off - Shortage delivery:**
1. Staff cannot deliver full quantity
2. Mark what's being delivered vs expected
3. Explain reason for shortage
4. Set new delivery date for remaining
5. Alert Admin and Cleaning team
6. If affects upcoming booking:
   - Admin decides: use backup linens or reschedule

**Damage during use:**
1. Cleaning staff finds damaged linen at property
2. Report via "Laundry Issue" form:
   - Item type
   - Damage description
   - Photo
   - Quantity affected
3. Remove damaged items
4. Request replacement via system
5. Laundry team delivers replacement
6. Update inventory

#### G.4 Proof of Work
**Required documentation:**

**Pick-up:**
- ✅ GPS check-in at property
- ✅ Photo of dirty linens before packing
- ✅ Count confirmation (digital checklist)
- ✅ Condition log (stained/damaged items)
- ✅ Timestamp of collection

**Wash/Dry:**
- ✅ Photos of sorted laundry (before wash)
- ✅ Batch processing log
- ✅ Quality check photos (after fold)
- ✅ Any issues documented

**Drop-off:**
- ✅ GPS check-in at property
- ✅ Photo of packaged clean linens
- ✅ Count verification
- ✅ Photo of organized storage
- ✅ Timestamp of delivery

**Benefits:**
- Accountability for all items
- Resolve disputes (guest claims vs actual)
- Track linen lifecycle
- Identify loss patterns
- Improve process efficiency

#### G.5 Integration với Inventory Module
**Automatic sync:**

**When pick-up submitted:**
- Deduct collected quantities from property linen inventory
- Mark as "In laundry process"
- Status shows "X items out for cleaning"

**When drop-off completed:**
- Add delivered quantities back to inventory
- Mark as "Available for use"
- Update last restock date

**Shortage handling:**
- If shortage > threshold (e.g. 20% of par level)
- Auto-create purchase order task
- Notify Admin to order new linens
- Track time to replenish

**Dashboard view:**
- Total linens per property
- Items in laundry (not available)
- Items available for use
- Items needing replacement
- Restock schedule

**Reports integration:**
- Linen costs included in inventory reports
- Replacement rate tracking
- Property comparison (which needs new linens most)
- Budget impact analysis

---

### Module H: QUẢN LÝ CHĂM SÓC SÂN VƯỜN & BỂ BƠI (Lawn & Pool Care Management)

#### H.1 Recurring & One-time Schedules
**Recurring tasks:**

**Lawn care examples:**
- Mowing: Weekly (every Monday)
- Edging: Bi-weekly
- Fertilization: Monthly (first week)
- Weed control: Monthly
- Mulch refresh: Quarterly
- Seasonal cleanup: Spring, Fall

**Pool care examples:**
- Skim & brush: 2x per week (Monday, Thursday)
- Vacuum: Weekly (Friday)
- Chemical check & balance: 2x per week
- Filter cleaning: Bi-weekly
- Equipment inspection: Monthly
- Acid wash: Quarterly

**Setup recurring schedule:**
1. Admin vào "Lawn/Pool" → "Create Schedule"
2. Select property
3. Choose service type
4. Set recurrence:
   - Frequency: Daily / Weekly / Bi-weekly / Monthly / Quarterly
   - Days of week (if weekly)
   - Time of day
   - Start date
   - End date (or ongoing)
5. Assign to vendor/team
6. Set auto-notifications
7. Save schedule
8. System auto-generates tasks per schedule

**One-time tasks:**
- Emergency cleanup after storm
- Pre-sale property grooming
- Special event preparation
- Pest treatment
- Tree trimming
- Hardscape repair

**Create one-time task:**
1. Click "Add One-time Task"
2. Select property and service
3. Set specific date/time
4. Priority level
5. Special instructions
6. Assign vendor
7. Create task

#### H.2 Property-Specific Profiles
**Lawn profile per property:**

**Property info:**
- Lot size: ___ sqft
- Grass type: Bermuda / St. Augustine / Zoysia / etc.
- Coverage: Full / Partial
- Slope/terrain: Flat / Sloped / Terraced
- Trees: Quantity and types
- Flower beds: Yes/No, locations
- Irrigation system: Yes/No, type
- Special features: Decorative rocks, statues, etc.

**Access info:**
- Gate code/key location
- Parking instructions
- Equipment storage location
- Water access points
- Pets on property: Yes/No

**Maintenance preferences:**
- Mowing height: ___ inches
- Clipping disposal: Bag / Mulch
- Edge definition: Sharp / Natural
- Weed tolerance: Zero / Low / Moderate

**Pool profile per property:**

**Pool specs:**
- Type: In-ground / Above-ground
- Material: Concrete / Fiberglass / Vinyl
- Size: ___ gallons
- Shape: Rectangle / Kidney / Freeform
- Features: Spa, waterfall, fountain
- Depth: Shallow ___, Deep ___

**Equipment:**
- Filter type: Sand / Cartridge / DE
- Pump model and location
- Heater: Yes/No, type
- Automation system: Yes/No, brand
- Cleaner type: Manual / Suction / Robotic

**Chemical targets:**
- pH: 7.4 - 7.6
- Chlorine: 2-4 ppm
- Alkalinity: 80-120 ppm
- Calcium hardness: 200-400 ppm

**Access & safety:**
- Gate code/lock info
- Equipment room access
- Chemical storage location
- Safety equipment on-site
- Pool cover: Yes/No

#### H.3 Proof of Work Requirements
**GPS check-in/out:**

**Check-in when arrive:**
- GPS coordinates logged
- Timestamp recorded
- Photo of property (entrance or yard overview)
- Note any pre-existing issues

**Check-out when leave:**
- GPS coordinates logged
- Timestamp recorded
- Total time on-site calculated
- Distance from property verified (can't check-out remotely)

**Before photos - Required:**
1. Overview shots:
   - Front yard (full view)
   - Backyard (full view)
   - Pool area (if applicable)
2. Problem areas:
   - Overgrown sections
   - Weeds
   - Debris
   - Dirty pool water
3. Close-ups of areas needing attention

**After photos - Required:**
1. Same angles as Before photos:
   - Show transformation
   - Demonstrate quality
2. Detail shots:
   - Clean edges
   - Mowed patterns
   - Clear pool water
   - Organized equipment
3. Completed work areas:
   - Trimmed trees/shrubs
   - Cleaned flowerbeds
   - Cleared debris

**Pool-specific documentation:**
1. Chemical test strip photo:
   - Must be legible
   - Shows all parameters
   - Timestamp visible
2. Equipment check photo:
   - Filter pressure gauge
   - Pump operation
   - Timer settings (if adjusted)
3. Water clarity photo:
   - See bottom of deep end
   - No visible debris
4. Chemical log entry:
   - Current readings
   - Chemicals added (type & amount)
   - Adjustments made
   - Next service recommendations

**Quality standards:**
- All photos must be clear, well-lit
- Minimum 2 photos per area (before/after)
- GPS data must match property location
- Time-on-site must be reasonable (not too short)
- Cannot submit without required photos

#### H.4 Overdue Alerts & Missed Check-ins
**Automated monitoring:**

**Overdue task alerts:**

**15 minutes after scheduled start:**
- "⏰ Task starting soon: [Service] at [Property] scheduled for [Time]"
- Sent to assigned vendor

**30 minutes after scheduled start - No check-in:**
- "⚠️ No check-in: [Vendor] has not started [Service] at [Property]"
- Sent to vendor AND Admin
- Task highlighted yellow on dashboard

**2 hours after scheduled start - Still no check-in:**
- "🚨 LATE: [Service] at [Property] is 2 hours overdue"
- SMS + Push notification to vendor
- Email + Push to Admin
- Task highlighted red
- Admin can call vendor or reassign

**Missed check-out:**
- If check-in occurred but no check-out after expected duration + 2 hours
- "⚠️ Incomplete: [Vendor] checked-in but hasn't checked out"
- Could indicate issue or forgotten check-out
- Admin follows up

**Escalation:**
- After 4 hours overdue with no response:
  - Admin manually contacts vendor
  - Prepare backup vendor if needed
  - Document in system for performance review

**Pattern detection:**
- System tracks missed/late check-ins per vendor
- If > 3 incidents in a month:
  - Alert Admin for review
  - Consider reassignment or warning
- Generate reliability report

#### H.5 Roles & Permissions by Team
**Strict separation:**

**Lawn Care Team:**
- Access ONLY lawn-related tasks
- Cannot see pool, cleaning, maintenance tasks
- Can view only assigned properties
- Submit lawn work proof only

**Pool Care Team:**
- Access ONLY pool-related tasks
- Cannot see lawn, cleaning, maintenance
- View pool profiles and chemical logs
- Submit pool service reports

**Why separation:**
- Data security: Vendors only see what they need
- Prevent confusion: Clear scope of work
- Accountability: Track performance by specialty
- Competitive info: Teams don't see each other's pricing/schedules

**Vendor management:**
- Each vendor has unique login
- Can have multiple crew members under one account
- Admin can:
  - View all vendor activity
  - Compare performance
  - Reassign properties
  - Suspend/activate accounts
  - View historical reliability

**Performance tracking:**
- On-time completion rate
- Quality score (based on photo reviews)
- Response time to alerts
- Number of incidents
- Customer feedback (if applicable)
- Cost efficiency

---

## 3. REPORTING & OVERSIGHT

### 3.1 Cleaning Reports
**Metrics tracked:**

**Daily Report:**
- Tasks scheduled vs completed
- Completion rate %
- Average time per property
- Photos uploaded count
- AI quality alerts triggered
- Damages/issues reported

**Weekly Report:**
- Total properties cleaned
- Staff performance comparison
- On-time completion rate
- SLA compliance: % completed within deadline
- Common issues identified
- Top performers recognition

**Monthly Report:**
- Trends analysis (compare to previous months)
- Property-specific cleaning history
- Staff efficiency over time
- Quality improvement metrics
- Cost analysis (labor hours × rate)
- Owner-ready summary

**SLA Compliance tracking:**
- Define SLAs: e.g., "Clean within 4 hours of checkout"
- Track: Scheduled time vs actual completion time
- Calculate: % of tasks meeting SLA
- Alert when SLA at risk
- Report failures with reasons

### 3.2 Maintenance Reports
**Weekly Log:**
- Open tickets: Count by priority
- Closed tickets: Count and resolution time
- New issues reported
- Recurring problems by property
- Parts/materials used
- Labor hours logged
- Tasks carried forward to next week

**Monthly Log:**
- Total maintenance hours
- Cost breakdown: Labor + Materials
- Property maintenance ranking (most issues → least)
- Preventive maintenance compliance
- Average resolution time by issue type
- Vendor performance (if external)
- Recommendations for property improvements

**Issue Resolution Tracking:**
- Mean Time To Repair (MTTR)
- First-time fix rate
- Repeat issues within 30 days
- Guest-impacting vs non-impacting issues

### 3.3 Inventory Reports
**Weekly Report:**
- Current stock levels (all properties, all items)
- Items below par level (alert list)
- Restocks completed this week
- Shortage incidents
- Properties needing urgent attention
- Estimated cost to replenish all

**Monthly Report:**
- Total usage by category
- Cost analysis: Total spent on supplies
- Usage per property (high → low consumers)
- Waste/damage costs
- Inventory turnover rate
- Comparison to previous month
- Budget forecast next month
- Recommendations:
  - Buy in bulk for common items
  - Reduce par levels for slow-moving items
  - Investigate high-usage properties

**Budget Impact:**
- Monthly spend per property
- Cost per guest stay
- Variance from budget
- Yearly projection
- Cost-saving opportunities

### 3.4 Laundry Reports
**Weekly Report:**
- Linen counts: Picked up vs Delivered
- Shortages logged
- Damaged items count & cost
- Properties served
- Turnaround time (pick-up to drop-off)

**Monthly Report:**
- Total linens processed
- Damage rate %
- Loss rate %
- Replacement costs
- Property linen inventory status
- Items due for replacement (usage cycles)
- Cost per property
- Efficiency metrics (items per hour)

**Linen Lifecycle:**
- Track usage cycles per item
- Alert when nearing replacement threshold
- Budget for replacements
- Quality degradation reports

### 3.5 Lawn & Pool Reports
**Weekly Report:**
- Services completed vs scheduled
- On-time completion rate
- Weather delays/reschedules
- Issues reported
- Before/after photo compliance
- Vendor performance scores

**Monthly Report:**
- Total services by type
- Cost per property per month
- Seasonal variations
- Chemical usage trends (pool)
- Vendor reliability scores
- Properties needing extra attention
- Recurring issues by property
- Budget vs actual spend
- Recommendations for optimization

**Chemical tracking (Pool):**
- Chemical consumption rates
- Cost per gallon treated
- Balance maintenance success rate
- Equipment efficiency
- Seasonal cost variations

### 3.6 Export Functionality
**Format options:**

**CSV Export:**
- Raw data, all fields
- Easy to import into Excel/Google Sheets
- Best for: Custom analysis, data manipulation
- Includes: All transaction details, timestamps, IDs

**PDF Export:**
- Formatted, professional layout
- Includes: Charts, graphs, summary tables
- Company logo and branding
- Best for: Presentations, owner reports, printing
- Options: Detailed or Summary view

**Excel Export:**
- Pre-formatted workbook
- Multiple sheets per report type
- Includes formulas and pivot tables
- Charts auto-generated
- Best for: Advanced analysis

**Email Delivery:**
- Schedule automatic delivery
- Daily/Weekly/Monthly
- Select recipients
- Choose format (PDF/CSV/Excel)
- Add custom message
- Attach supporting photos

**Owner Portal Access:**
- Property owners login to view reports
- Filter by their properties only
- Download on-demand
- Subscribe to automated reports
- View historical reports archive

---

## 4. NOTIFICATIONS & ALERTS

### 4.1 Daily To-Do Reminders
**Staff wake-up notification:**

**Timing:** 7:00 AM (configurable per staff)

**Content:**
```
☀️ Good morning [Staff Name]!
You have [X] tasks today:

🏠 Property A - Check-out clean (Due: 11:00 AM)
🏠 Property B - Maintenance (Due: 2:00 PM)
🏠 Property C - Check-in prep (Due: 4:00 PM)

Tap to view details and start your day!
```

**Features:**
- Shows task count
- Lists top 3 priorities
- One-tap to open app
- Shows estimated total hours
- Weather alert if relevant (rain affects lawn/pool)

### 4.2 Task Reminders
**24 hours before:**

**Notification:**
```
📅 Tomorrow's Schedule
[Task Name] at [Property Name]
Due: Tomorrow at [Time]
Location: [Address]
Estimated duration: [X] hours

Tap to view checklist and prepare
```

**Purpose:**
- Give staff time to plan route
- Check equipment needed
- Review special instructions
- Prepare materials

**2 hours before start:**

**Notification:**
```
⏰ Starting Soon
[Task Name] begins in 2 hours
Property: [Name]
Address: [Full address]
📍 [Map Link]

Required:
✓ Cleaning supplies
✓ Camera for photos
✓ [Special items]

Tap to start task
```

**Features:**
- Direct link to maps/navigation
- Checklist of required items
- One-tap check-in
- Shows current traffic conditions

**30 minutes before:**

**Final reminder:**
```
⏰ STARTING IN 30 MINUTES
[Task Name] at [Property Name]

Don't forget to:
✓ Check-in with GPS
✓ Take Before photos
✓ Follow the checklist

Start task now?
[Start Task Button]
```

### 4.3 Overdue/Missed Check-in Alerts
**For Staff:**

**15 minutes after scheduled start - No check-in:**
```
⚠️ Did you forget to check in?
Task: [Name] was scheduled for [Time]
You haven't checked in yet.

Everything okay?
[Check In Now] [Report Issue]
```

**For Admin:**

**30 minutes overdue:**
```
⚠️ LATE TASK ALERT
Staff: [Name]
Task: [Task Name] at [Property]
Scheduled: [Time]
Status: Not started

Actions:
[Contact Staff] [Reassign Task] [View Details]
```

**2 hours overdue:**
```
🚨 CRITICAL: Task Significantly Overdue
[Full details]
No response from staff

Recommended actions:
• Call staff member immediately
• Check last known location
• Prepare backup coverage
• Alert property owner if affects guest
```

### 4.4 Low Stock & Shortage Notifications
**Low stock warning:**

**To Maintenance Team:**
```
⚠️ LOW STOCK ALERT
Property: [Name]
Items below minimum:
• Toilet paper: 2 (min: 6)
• Hand soap: 1 (min: 4)
• Trash bags: 3 (min: 10)

Restock task created: #TASK123
Due: [Date]

[View Task] [View Full Inventory]
```

**To Admin:**
```
📊 Daily Stock Report
3 properties need restocking:

🏠 Property A - 5 items low
🏠 Property B - 3 items low
🏠 Property C - 2 items critical

Total estimated cost: $[Amount]

[View Details] [Approve Bulk Order]
```

**Shortage (Out of stock):**

**Critical shortage:**
```
🚨 CRITICAL SHORTAGE
Property: [Name]
Item: Toilet paper
Current stock: 0
Guest checking in: TOMORROW 3:00 PM

URGENT restock required!

[Assign to Maintenance] [Contact Staff]
```

**Auto-actions:**
- Creates high-priority task
- Sends SMS + Push + Email
- Escalates if not acknowledged in 1 hour
- Flags property as "At risk" for upcoming booking

### 4.5 QA Alerts from Photo Inspections
**When AI detects issues:**

**To Staff (immediate):**
```
⚠️ QUALITY ISSUE DETECTED
Your cleaning photos for [Property] show:

❌ Issue found in Bathroom:
• Residue detected on mirror
• Location: [Highlighted on photo]

Please review and re-clean if necessary.

[View Photos] [Re-clean] [Explain Issue]
```

**Options for staff:**
1. **Re-clean:**
   - Go back and fix
   - Take new photos
   - Resubmit

2. **Explain:**
   - "Vết cũ không thể làm sạch"
   - "Cần sản phẩm chuyên dụng"
   - "Cần maintenance để fix"
   - Send to Admin for review

**To Admin:**
```
🔍 QA REVIEW NEEDED
Property: [Name]
Staff: [Name]
Issues detected: 2

1. Bathroom mirror - residue
   Staff response: "Old stain, needs special treatment"
   
2. Kitchen counter - clutter visible
   Staff response: [Pending]

[Approve Anyway] [Request Re-clean] [Create Maintenance Task]
```

**Dashboard summary:**
```
📊 Daily QA Summary
Total cleanings: 12
Passed AI check: 10 (83%)
Flagged for review: 2

Common issues:
• Mirror/glass residue: 3 incidents
• Clutter not removed: 1 incident

[View Details] [Staff Training Needed]
```

### 4.6 Urgent Issue Alerts from Staff
**Staff submission:**
```
Staff presses 🚨 URGENT ALERT button

Categories:
• Emergency (fire, flood, injury)
• Access issue (can't enter)
• Safety hazard
• Equipment failure
• Guest still present
• Other critical issue

[Upload Photos] [Record Voice Note] [Type Details]
```

**Admin receives:**
```
🚨🚨🚨 URGENT ALERT 🚨🚨🚨
From: [Staff Name]
Property: [Name]
Type: Access Issue

"Gate code not working, cannot enter property. 
Guest checking in 2 hours."

📸 [3 photos attached]
📍 [GPS location - staff is on-site]
⏰ Reported: 2 minutes ago

ACKNOWLEDGE REQUIRED WITHIN 15 MIN

[Call Staff] [Call Owner] [Acknowledge] [Dispatch Help]
```

**Multi-channel delivery:**
- Push notification (immediate)
- SMS (immediate)
- Phone call if not acknowledged in 5 min
- Email (for record)
- Dashboard red banner

**Escalation:**
- 15 min no response → Notify backup admin
- 30 min no response → Notify operations manager
- 1 hour no response → Automatic protocols trigger

**Resolution tracking:**
- Time to acknowledge
- Time to resolve
- Actions taken
- Outcome
- Preventive measures
- Add to incident log

---

## 5. ACCEPTANCE CRITERIA (MVP "DEFINITION OF DONE")

### 5.1 Schedule Import & Auto-Generation
**Requirement:**
Admin uploads schedule → System auto-generates tasks

**Test scenarios:**

**Scenario 1: CSV Upload**
1. Admin uploads CSV with 10 properties
2. Each has check-in/check-out dates
3. Expected result:
   - 10 check-out cleaning tasks created
   - 10 check-in prep tasks created
   - All tasks assigned to default team
   - Calendar shows all 20 tasks
   - Staff receive notifications

**Scenario 2: Multiple Properties Same Day**
1. Upload schedule: 5 properties check-out same day
2. Expected:
   - Tasks created with time slots (avoid overlap)
   - Consider travel time between properties
   - Distribute across available staff
   - Alert if insufficient staff

**Scenario 3: Recurring Maintenance**
1. Setup monthly AC filter change for Property A
2. Expected:
   - Task auto-created on 1st of each month
   - Assigned to maintenance team
   - Reminder sent 2 days before
   - Continues until manually stopped

**Acceptance:**
✅ 100% of uploaded schedules create tasks
✅ No duplicate tasks
✅ All tasks have complete information
✅ Calendar reflects all tasks immediately
✅ Notifications sent to all assigned staff

### 5.2 Staff Notifications & Checklist Completion
**Requirement:**
Staff get push notifications → complete checklists & upload proof

**Test scenarios:**

**Scenario 1: Morning To-Do**
1. Staff opens app at 7:00 AM
2. Expected:
   - Sees complete list of today's tasks
   - Sorted by time/priority
   - Can tap to view details
   - Shows route on map

**Scenario 2: Complete Cleaning Task**
1. Staff starts task
2. Must GPS check-in (verified)
3. Must take Before photos (minimum 4)
4. Complete room-by-room checklist
5. Cannot skip required steps
6. Take After photos (minimum 4)
7. Submit task
8. Expected:
   - All steps enforced
   - Cannot submit if incomplete
   - GPS logged throughout
   - Photos timestamped

**Acceptance:**
✅ Notifications delivered within 1 minute
✅ Checklist cannot be bypassed
✅ App works offline (syncs when online)
✅ Photos compressed but readable
✅ GPS accuracy within 50 meters

### 5.3 Required Photos & Checklists
**Requirement:**
Tasks cannot be marked complete without required checklists/photos

**Test scenarios:**

**Scenario 1: Try to Submit Without Photos**
1. Staff completes checklist
2. Tries to submit without uploading photos
3. Expected:
   - Submit button disabled
   - Error message: "Please upload required Before and After photos"
   - Shows count: "0/4 Before photos, 0/4 After photos"

**Scenario 2: Incomplete Checklist**
1. Staff uploads photos
2. Completes 80% of checklist
3. Tries to submit
4. Expected:
   - Cannot submit
   - Highlights incomplete items
   - "3 items remaining in Bathroom checklist"

**Scenario 3: All Requirements Met**
1. Staff completes 100% checklist
2. Uploads all required photos
3. GPS check-in/out completed
4. Submit button enabled
5. Task submitted successfully
6. Status → Completed
7. Admin notified

**Acceptance:**
✅ Impossible to submit incomplete tasks
✅ Clear error messages guide staff
✅ Visual indicators show progress
✅ System validates all requirements before submission

### 5.4 AI Photo Quality Check
**Requirement:**
AI auto-checks cleaning photos → alerts admin if issues detected

**Test scenarios:**

**Scenario 1: Detect Mirror Residue**
1. Staff uploads After photo of bathroom
2. Mirror has water spots/streaks
3. Expected:
   - AI scans photo (5-10 seconds)
   - Detects residue
   - Highlights area on photo
   - Alert sent to staff: "Issue detected - please review"
   - Alert sent to admin
   - Staff can re-clean or explain

**Scenario 2: Detect Clutter**
1. After photo shows items on floor
2. Expected:
   - AI flags as "Clutter detected"
   - Staff notified
   - Task marked for admin review

**Scenario 3: Clean Photos Pass**
1. All photos show spotless rooms
2. Expected:
   - AI validates quality
   - Auto-approves
   - Task moves to Verified
   - Staff gets positive feedback: "✅ Great work! Quality check passed"

**Acceptance:**
✅ AI detection accuracy >80%
✅ False positives <10%
✅ Processing time <30 seconds per task
✅ Staff can dispute AI findings
✅ Admin has final approval authority

### 5.5 Damage/Lost Items Reporting
**Requirement:**
Damages/lost items reported with photo & logged

**Test scenarios:**

**Scenario 1: Report Broken Item**
1. Staff finds broken lamp during cleaning
2. Clicks "Report Damage"
3. Selects category: Damage
4. Location: Living Room
5. Takes 3 photos from different angles
6. Description: "Table lamp broken, glass shattered"
7. Severity: Medium
8. Submits report
9. Expected:
   - Report logged with timestamp, GPS
   - Admin notified immediately
   - Maintenance task auto-created
   - Added to property damage history
   - Shows on property profile

**Scenario 2: Log Lost & Found**
1. Staff finds phone charger left by guest
2. Logs in Lost & Found
3. Takes photos
4. Description: "iPhone charger, white, Apple brand"
5. Expected:
   - Item cataloged with unique ID
   - Admin notified
   - Shows in Lost & Found dashboard
   - Status: Found → Admin contacts guest

**Acceptance:**
✅ All reports require photo proof
✅ Reports timestamped and geotagged
✅ Searchable database
✅ Automated workflows trigger
✅ History tracked per property

### 5.6 Shortage → Auto Inventory Task
**Requirement:**
Cleaning shortages auto-generate inventory tasks → maintenance team replenishes & logs

**Test scenarios:**

**Scenario 1: Report Shortage During Cleaning**
1. Cleaner doing bathroom checklist
2. Finds no toilet paper to restock
3. Marks "Out of stock" in checklist
4. Takes photo of empty cabinet
5. Submits
6. Expected:
   - System creates inventory task automatically
   - Title: "Restock toilet paper at Property A"
   - Assigned to: Maintenance team
   - Priority: High (if guest checking in soon)
   - Notification sent to maintenance staff
   - Property flagged in system

**Scenario 2: Maintenance Restocks**
1. Maintenance receives task
2. Goes to property
3. Checks inventory levels
4. Brings supplies
5. Restocks items
6. Updates inventory:
   - Toilet paper: 0 → 12
   - Photos of restocked items
7. Submits task
8. Expected:
   - Inventory updated in real-time
   - Shortage resolved
   - Property cleared from at-risk list
   - Admin notified of completion

**Acceptance:**
✅ 100% of shortages create tasks
✅ Tasks created within 1 minute of report
✅ Correct items and quantities specified
✅ Proper prioritization based on urgency
✅ Closed-loop: Shortage reported → Task created → Restocked → Verified

### 5.7 Automated Report Generation & Export
**Requirement:**
Weekly/monthly reports auto-generate & export

**Test scenarios:**

**Scenario 1: Weekly Report Auto-Generation**
1. Every Monday at 8:00 AM
2. Expected:
   - System generates reports for previous week
   - Cleaning report: Tasks completed, staff performance
   - Maintenance report: Issues resolved, pending items
   - Inventory report: Usage, costs, shortages
   - All reports available in dashboard
   - Email sent to Admin with PDF attachments

**Scenario 2: Monthly Report**
1. First day of each month
2. Expected:
   - Comprehensive report for previous month
   - All modules included
   - Charts and graphs
   - Trends and comparisons
   - Export to PDF, CSV, Excel
   - Auto-email to property owners (if configured)

**Scenario 3: On-Demand Export**
1. Admin wants custom report
2. Selects date range, properties, metrics
3. Clicks "Generate Report"
4. Expected:
   - Report generated in 30 seconds
   - Choose format: PDF/CSV/Excel
   - Download or email
   - Save for future reference

**Acceptance:**
✅ Reports generated automatically on schedule
✅ All data accurate and complete
✅ Charts/graphs render correctly
✅ Exports in all formats work
✅ Email delivery 100% reliable
✅ Reports accessible in archive for 2 years

### 5.8 Unified Calendar
**Requirement:**
Unified calendar shows all tasks across teams

**Test scenarios:**

**Scenario 1: Admin Views All Tasks**
1. Admin opens calendar
2. Week view
3. Expected:
   - See all task types:
     - Cleaning (blue)
     - Maintenance (orange)
     - Laundry (purple)
     - Lawn care (green)
     - Pool care (teal)
   - Color-coded by type and status
   - Can filter by team/property
   - Shows staff assignments

**Scenario 2: Staff Views Only Their Tasks**
1. Cleaning staff opens calendar
2. Expected:
   - Sees only their assigned cleaning tasks
   - Cannot see other teams' tasks
   - Cannot see unassigned tasks
   - Clear view of their schedule

**Scenario 3: Drag & Drop Reschedule**
1. Admin needs to move task to different day
2. Drags task from Monday to Tuesday
3. Expected:
   - Task moves
   - Staff notification sent
   - Checks for conflicts
   - Updates reminders automatically

**Acceptance:**
✅ All tasks visible on unified calendar
✅ Real-time updates (no refresh needed)
✅ Filters work correctly
✅ Permissions enforced (staff see only their tasks)
✅ Drag-drop smooth and reliable
✅ Mobile-responsive design

### 5.9 In-App Chat with Media Sharing
**Requirement:**
In-app chat supports staff-admin coordination with media sharing

**Test scenarios:**

**Scenario 1: Staff Sends Photo via Chat**
1. Staff encounters issue during cleaning
2. Opens chat with Admin
3. Writes: "Found this damage, what should I do?"
4. Attaches photo
5. Sends
6. Expected:
   - Admin receives message instantly
   - Push notification
   - Photo displays in chat
   - Admin can reply
   - Conversation linked to property/task

**Scenario 2: Admin Sends Instructions**
1. Admin receives question
2. Responds with text + video
3. Video: How to use new cleaning product
4. Expected:
   - Staff receives immediately
   - Can play video in-app
   - Can download for offline viewing
   - Thread saved for reference

**Scenario 3: Group Chat**
1. Admin needs to update all cleaning staff
2. Sends message to Cleaning Team group
3. "New procedure for check-in preps"
4. Attaches PDF document
5. Expected:
   - All staff receive notification
   - Can open PDF in-app
   - Can acknowledge receipt
   - Admin sees who read it

**Acceptance:**
✅ Messages delivered <2 seconds
✅ Photos/videos upload and display correctly
✅ Works on poor network (queues messages)
✅ Search functionality works
✅ Media auto-compressed
✅ Push notifications reliable
✅ Read receipts accurate

---

## 6. TECHNICAL NOTES

### 6.1 Shared Task Engine & Calendar
**Architecture:**

**Single source of truth:**
- All tasks (Cleaning, Maintenance, Laundry, Lawn, Pool) use same database schema
- Common fields: ID, Property, Type, Status, Assigned To, Due Date, Created Date, etc.
- Type-specific fields stored as JSON metadata

**Benefits:**
- Unified calendar can display all tasks
- Easy to track workload across teams
- Simplified reporting
- Consistent user experience
- Easier to maintain code

**Task Schema:**
```
Task {
  id: UUID
  property_id: UUID
  task_type: enum (CLEANING, MAINTENANCE, LAUNDRY, LAWN, POOL)
  title: string
  description: text
  assigned_to: UUID (staff/vendor)
  created_by: UUID (admin)
  priority: enum (LOW, MEDIUM, HIGH, URGENT)
  status: enum (PENDING, IN_PROGRESS, BLOCKED, COMPLETED, VERIFIED, CANCELLED)
  due_date: datetime
  created_at: datetime
  updated_at: datetime
  gps_check_in: {lat, lng, timestamp}
  gps_check_out: {lat, lng, timestamp}
  photos_before: [URLs]
  photos_after: [URLs]
  metadata: JSON (task-specific data)
  checklist: JSON (if applicable)
  notes: text
}
```

### 6.2 Photo Compression & Metadata
**Implementation:**

**Compression:**
- Client-side compression before upload
- Target: Max 2MB per photo, quality 80%
- Maintain aspect ratio
- EXIF data preserved
- Progressive JPEG for faster loading

**Metadata extraction:**
- GPS coordinates (lat/lng)
- Timestamp (capture time, not upload time)
- Device info (for troubleshooting)
- Camera settings (if available)

**Watermark (Optional):**
- Staff name
- Property name
- Date & time
- Subtle, corner placement
- For accountability and proof

**Storage:**
- Cloud storage (AWS S3, Google Cloud Storage)
- Organized by: Property / Date / Task Type
- Naming: `{property_id}/{date}/{task_id}/{photo_type}_{sequence}.jpg`
- Lifecycle: Keep for 2 years, then archive

**Security:**
- Signed URLs (temporary access)
- No public access
- Encrypted in transit and at rest
- Access logs for compliance

### 6.3 Push Notifications
**Platform:**
- iOS: Apple Push Notification Service (APNS)
- Android: Firebase Cloud Messaging (FCM)
- Web: Web Push API

**Notification types:**
1. **Task reminders:** Scheduled based on task due time
2. **Alerts:** Immediate delivery (shortage, damage, urgent)
3. **Chat messages:** Real-time
4. **Status updates:** When task status changes
5. **QA alerts:** When AI detects issues

**User preferences:**
- Enable/disable by category
- Quiet hours (no notifications 10 PM - 6 AM)
- Sound on/off
- Vibration on/off

**Delivery guarantee:**
- Retry on failure (max 3 attempts)
- Fallback to SMS for critical alerts
- Log all notifications sent
- Track delivery and open rates

**Badge counts:**
- Show unread notifications count on app icon
- Update in real-time
- Clear when notifications viewed

### 6.4 CSV/PDF Reporting Exports
**CSV Export:**
- Raw data, all columns
- UTF-8 encoding
- Header row with field names
- Date format: ISO 8601 (YYYY-MM-DD HH:MM:SS)
- Currency formatted consistently
- No special characters that break parsing

**PDF Export:**
- Professional template with branding
- Header: Company logo, report title, date range
- Executive summary (first page)
- Detailed tables with pagination
- Charts and graphs (generated as images)
- Footer: Page numbers, generation timestamp
- Optimized for printing (A4 or Letter)

**Excel Export:**
- Multiple sheets (one per report type)
- Formatted tables with filters
- Pre-built pivot tables
- Charts on separate sheets
- Formulas preserved
- Color-coding for status/priority
- Freeze panes for easy scrolling

**Generation process:**
- Background job (don't block UI)
- Progress indicator
- Email link when ready (for large reports)
- Cache for 24 hours (regenerate if data changes)

### 6.5 AI Module for Photo QA
**Technology options:**
- Computer Vision API (Google Cloud Vision, AWS Rekognition, Azure Computer Vision)
- Custom trained model (TensorFlow, PyTorch)
- Hybrid: Pre-trained + fine-tuned on property cleaning images

**Detection capabilities:**
1. **Object detection:** Identify furniture, fixtures, appliances
2. **Cleanliness assessment:** Detect dust, stains, clutter
3. **Image comparison:** Before vs After similarity
4. **Text detection:** Read labels, expiry dates (inventory)
5. **Quality scoring:** 0-100 score based on multiple factors

**Training data:**
- Collect thousands of before/after photos
- Label: Clean vs Not Clean
- Annotate specific issues: dust, stain, clutter, etc.
- Regularly retrain with new data

**Implementation:**
1. Photo uploaded → Sent to AI API
2. API returns:
   - Detection results (objects, issues found)
   - Confidence scores
   - Bounding boxes for issues
   - Overall quality score
3. System processes results:
   - If score < threshold (e.g., 70): Alert staff
   - If critical issue: Alert admin
   - If score > 90: Auto-approve

**Performance:**
- Process time: 5-30 seconds per photo
- Batch processing for multiple photos
- Cache results to avoid reprocessing
- Fallback: Manual review if AI fails

**Continuous improvement:**
- Track false positives/negatives
- Staff can flag incorrect detections
- Use feedback to retrain model
- A/B test different models
- Monitor accuracy metrics monthly

---

## 7. LUỒNG NGHIỆP VỤ TỔNG HỢP (End-to-End Workflows)

### 7.1 Luồng công việc hoàn chỉnh: Từ Schedule → Cleaning → QA
**Timeline: Guest Checkout to Next Guest Check-in**

**Day 0 - Schedule Import:**
1. 🔄 Admin uploads weekly schedule (CSV)
2. ✅ System parses and creates tasks
3. 📤 Cleaning tasks auto-generated based on checkout times
4. 👥 Tasks assigned to cleaning staff
5. 🔔 Staff receive weekly preview notification

**Day 1 - Guest Checkout (11:00 AM):**
1. ✅ Guest checks out
2. 🔔 Cleaner receives notification: "Property A ready for cleaning"
3. 🚗 Cleaner reviews task, checks route
4. 🔔 2-hour reminder: "Task starts at 12:00 PM"

**12:00 PM - Cleaning Begins:**
1. 📍 Cleaner arrives, GPS check-in
2. 📸 Takes Before photos (all rooms)
3. ✅ Opens checklist, begins cleaning
4. 🧹 Completes room-by-room:
   - Living room checklist (15 min)
   - Kitchen checklist (20 min)
   - Bedrooms checklist (25 min)
   - Bathrooms checklist (30 min)
5. ⚠️ Finds: Missing toilet paper in bathroom #2
6. 📝 Flags shortage in checklist
7. 🔔 System auto-creates inventory task for Maintenance

**2:00 PM - Cleaning Complete:**
1. 📸 Takes After photos
2. ✅ Reviews checklist: 100% complete
3. 📤 Submits task
4. 📍 GPS check-out

**2:05 PM - AI Quality Check:**
1. 🤖 AI scans After photos
2. ⚠️ Detects: Water streaks on bathroom mirror
3. 🔔 Alert sent to cleaner: "Issue detected in Bathroom #1"
4. 🔔 Alert sent to admin for review

**2:10 PM - Cleaner Response:**
1. 📱 Cleaner reviews AI feedback
2. ✅ Decides to re-clean mirror
3. 🚗 Returns to property
4. 🧹 Re-cleans bathroom mirror
5. 📸 Takes new After photo
6. 📤 Resubmits

**2:30 PM - Final QA:**
1. 🤖 AI rescans photos
2. ✅ Quality check passed
3. ✅ Task auto-approved
4. 🔔 Admin notified: "Property A verified clean"
5. 🏠 Property status: Ready for next guest

**3:00 PM - Maintenance Restocks:**
1. 🔔 Maintenance staff sees inventory task
2. 🚗 Goes to supply room, gets toilet paper
3. 🚗 Drives to Property A
4. 📍 GPS check-in
5. 🧻 Restocks toilet paper (12 rolls)
6. 📸 Takes photo of restocked cabinet
7. 📝 Updates inventory: 0 → 12 rolls
8. ✅ Marks task complete
9. 📍 GPS check-out

**4:00 PM - Guest Check-in Prep:**
1. 🔄 System automatically creates check-in prep task
2. 👤 Assigned to senior cleaner
3. 📋 Final walkthrough checklist:
   - All rooms spotless ✅
   - All supplies stocked ✅
   - Temperature set correctly ✅
   - Lights working ✅
   - Welcome kit placed ✅
4. 📸 Final photos for records
5. ✅ Property marked "Guest-Ready"

**5:00 PM - Guest Arrives:**
1. 🏠 Guest checks in smoothly
2. ✅ No issues reported
3. 🎉 Successful turnover!

**End of Day - Reporting:**
1. 📊 Admin reviews daily summary
2. ✅ Property A: Completed on time
3. 📈 Quality score: 95/100
4. 💰 Costs logged: 2 hours cleaning + supplies
5. 📤 Report auto-generated and emailed to property owner

### 7.2 Luồng xử lý sự cố khẩn cấp
**Scenario: Broken Pipe During Cleaning**

**12:30 PM - Discovery:**
1. 🧹 Cleaner working in bathroom
2. 💧 Notices water leaking from under sink
3. 🚨 Recognizes as emergency
4. 🛑 Stops cleaning immediately

**12:32 PM - Report Emergency:**
1. 📱 Opens app, clicks "🚨 URGENT ALERT"
2. ✅ Selects: "Emergency - Water Leak"
3. 📸 Takes photos/video of leak
4. 🎤 Records voice note: "Pipe broken under sink, water spreading"
5. 📤 Submits alert

**12:33 PM - Admin Notified:**
1. 🔔 Push + SMS + Email to Admin
2. 📱 Admin's phone rings (escalation)
3. 👤 Admin sees full report with photos
4. ⏱️ Acknowledges within 2 minutes

**12:35 PM - Admin Response:**
1. 📞 Calls cleaner: "Turn off water main if you can"
2. 💬 Instructs cleaner via chat with photo of shut-off valve location
3. 🔧 Creates emergency maintenance task
4. 📞 Calls maintenance lead
5. 📞 Calls plumber (external vendor)

**12:40 PM - Cleaner Actions:**
1. 💧 Finds and turns off water main (following admin's photo guide)
2. 🧹 Uses towels to soak up standing water
3. 📸 Takes photos of mitigated situation
4. 📤 Updates incident: "Water stopped, cleaned up surface water"
5. 💬 Chats admin: "Should I continue cleaning other rooms?"

**12:45 PM - Admin Coordination:**
1. 💬 Responds to cleaner: "Yes, finish other rooms. Avoid bathroom."
2. 📞 Plumber confirms arrival in 30 minutes
3. 🔑 Arranges property access for plumber
4. 📝 Updates incident ticket with timeline
5. 📅 Checks guest check-in time: 4:00 PM today
6. 😰 Realizes tight timeline

**1:00 PM - Cleaner Completes Other Areas:**
1. ✅ Finishes living room, bedrooms, kitchen
2. 🚫 Marks bathroom as "Blocked - Emergency repair"
3. 📸 Takes photos of completed areas
4. 📍 GPS check-out
5. 💬 Chats admin: "All done except bathroom. Will return after plumber finishes."

**1:15 PM - Plumber Arrives:**
1. 📍 Plumber checks in via app (vendor access)
2. 🔧 Assesses damage
3. 📞 Calls admin: "Need to replace pipe section, 90 minutes"
4. 💬 Updates task: "In progress - pipe replacement"
5. 📸 Takes before photos

**2:45 PM - Repair Complete:**
1. 🔧 Plumber finishes repair
2. 💧 Tests water - no leaks
3. 📸 Takes after photos
4. 📝 Logs: "Replaced 2-foot section of PVC pipe under sink"
5. 💰 Notes cost: $150 labor + $30 parts
6. ✅ Marks task complete
7. 📍 Checks out

**2:50 PM - Cleaner Returns:**
1. 🔔 Receives notification: "Plumber finished, bathroom ready"
2. 🚗 Returns to property
3. 📍 Checks in again
4. 🧹 Completes bathroom cleaning
5. 🧽 Extra sanitizing due to water damage
6. 📸 Takes final photos
7. ✅ Completes full checklist
8. 📤 Submits task

**3:15 PM - Final QA:**
1. 🤖 AI checks photos - all clear
2. 👤 Admin personally reviews due to incident
3. ✅ Admin approves: "Excellent recovery!"
4. 🏠 Property marked ready

**3:30 PM - Guest Notification:**
1. 📧 Admin emails property owner: "Minor plumbing issue resolved"
2. 📄 Attaches incident report with timeline and photos
3. 💰 Includes repair costs
4. ✅ Confirms property ready for 4:00 PM check-in

**4:00 PM - Guest Checks In:**
1. 🏠 Guest arrives, no issues
2. 💧 Water works perfectly
3. 🧼 Bathroom spotless
4. ✅ Guest happy

**Post-Incident:**
1. 📊 Incident logged in system
2. 📈 Analytics: Total response time: 1h 15min (emergency resolved)
3. 🎯 Property flagged for preventive maintenance check
4. 📋 Admin creates task: "Inspect all plumbing" for next month
5. 💬 Team debrief: What went well, what to improve
6. 🏆 Cleaner receives recognition for quick response

**Lessons documented:**
- Water main location should be in property profile
- Keep emergency supplies (towels) in cleaning kit
- Response time excellent: <5 minutes
- Coordination via chat worked well
- Plumber vendor reliable

---

## 8. TÍNH NĂNG NÂNG CAO (Advanced Features)

### 8.1 Offline Mode
**Challenge:** Staff working in areas with poor connectivity

**Solution:**

**App functionality offline:**
1. ✅ View assigned tasks (synced before leaving)
2. ✅ Complete checklists
3. ✅ Take photos (stored locally)
4. ✅ Record GPS (cached)
5. ✅ Write notes
6. 🔄 Queue all actions

**When connection restored:**
1. 🔄 Auto-sync all queued data
2. 📤 Upload photos in background
3. ✅ Update task statuses
4. 🔔 Receive queued notifications
5. ⚠️ Alert if conflicts (task reassigned while offline)

**User experience:**
- 📶 Connection indicator always visible
- 🔄 Sync progress bar
- ⚠️ "Working offline" banner
- 📊 Shows data usage (for photo uploads)
- ⚡ Option to sync only on WiFi

### 8.2 Analytics Dashboard
**For Admin - Data-driven insights:**

**Performance Metrics:**
1. **Task completion rates:**
   - By team: Cleaning 95%, Maintenance 88%, Laundry 98%
   - By staff: Individual performance rankings
   - Trend: Improving/declining over time

2. **Quality scores:**
   - Average AI quality score: 87/100
   - Pass rate: 85% first time
   - Common issues: Mirror streaks (15%), Clutter (8%)
   - Staff comparison: Who has highest quality

3. **Response times:**
   - Average time to start task after notification
   - Average completion time per property type
   - Benchmark against goals

4. **Cost analysis:**
   - Labor costs by property
   - Supply costs per property
   - Maintenance costs trends
   - ROI on preventive maintenance

**Visualizations:**
- 📊 Bar charts: Tasks by type, by status
- 📈 Line graphs: Trends over time
- 🥧 Pie charts: Cost breakdowns
- 🗺️ Heat maps: Properties needing most attention
- 📅 Gantt charts: Schedule optimization

**Predictive analytics:**
- 🔮 Forecast: Properties likely to have issues
- 📊 Predict: Inventory needs based on booking patterns
- ⚠️ Alert: Staff burnout risk (too many tasks)
- 💡 Suggest: Best staff for specific properties

### 8.3 Mobile App Features
**Designed for on-the-go workers:**

**UI/UX optimizations:**
- 👍 Large, thumb-friendly buttons
- 📱 Swipe gestures for common actions
- 🔊 Voice input for notes
- 📸 Quick camera access
- 🗺️ Integrated maps for navigation
- 🌙 Dark mode for outdoor work
- 🔋 Battery optimization

**Smart features:**
1. **Route optimization:**
   - Orders tasks by proximity
   - Calculates drive time
   - Suggests best route
   - Integrates with Google Maps/Waze

2. **Quick actions:**
   - Swipe right: Mark complete
   - Swipe left: Report issue
   - Long press: Call admin
   - Shake to report emergency

3. **Voice commands:**
   - "Start next task"
   - "Take photo"
   - "Report shortage"
   - "Call admin"

4. **Widgets:**
   - Today's task count on home screen
   - Next task countdown
   - Quick check-in button

### 8.4 Integration Possibilities
**Connect with other systems:**

**Property Management Systems (PMS):**
- **Airbnb, Vrbo, Booking.com:**
  - Auto-import bookings
  - Sync check-in/check-out times
  - Update cleaning status
  - Block calendar when property not ready

**Accounting Software:**
- **QuickBooks, Xero:**
  - Export labor costs
  - Track expenses (supplies, repairs)
  - Generate invoices for property owners
  - Budget tracking

**Smart Home Devices:**
- **Smart locks:**
  - Generate temporary access codes for staff
  - Log entry/exit times
  - Remote unlock for emergencies

- **Smart thermostats:**
  - Auto-adjust temperature before guest arrival
  - Turn off when vacant
  - Track energy usage

- **Security cameras:**
  - Verify staff presence
  - Review incidents
  - Guest check-in confirmation

**Vendor Management:**
- **Plumber/Electrician databases:**
  - Auto-dispatch for emergencies
  - Track vendor performance
  - Manage contracts and rates

**Payment Processing:**
- **Stripe, PayPal:**
  - Process payments from property owners
  - Pay staff/vendors
  - Track transactions

### 8.5 Gamification for Staff Motivation
**Make work engaging:**

**Points system:**
- 🏆 10 points: Complete task on time
- 🌟 20 points: Pass AI quality check first time
- 💎 50 points: Perfect week (no issues)
- 🎯 100 points: Month with zero incidents
- ⚡ 5 points: Early completion

**Badges:**
- 🥇 "Speedster" - Fastest cleaner this week
- 🌟 "Quality Champion" - Highest quality scores
- 🦸 "Emergency Hero" - Best incident response
- 📸 "Perfectionist" - 100% photo compliance
- 🤝 "Team Player" - Most helpful to others

**Leaderboards:**
- 📊 Weekly rankings by points
- 🏆 Monthly champions
- 🌟 All-time leaders
- 👥 Team vs team competitions

**Rewards:**
- 🎁 Points redeemable for:
  - Gift cards
  - Extra time off
  - Bonus pay
  - Training opportunities
  - Equipment upgrades

**Social features:**
- 👏 Peer recognition: "Give kudos"
- 💬 Share success stories
- 🎉 Celebrate milestones
- 📸 "Before/After of the week" showcase

### 8.6 AI-Powered Insights
**Beyond photo QA:**

**Predictive maintenance:**
- 🔮 Analyze patterns: "Property A has plumbing issue every 3 months"
- 💡 Suggest: "Schedule preventive inspection"
- 📊 Predict: "AC filter due in 2 weeks based on usage"

**Smart scheduling:**
- 🧠 Learn optimal cleaning times per property
- 🚗 Factor in traffic patterns
- 👥 Match staff skills to property needs
- ⏱️ Predict accurate completion times

**Anomaly detection:**
- ⚠️ Alert: "Property B using 3x normal toilet paper"
- 🔍 Investigate: Possible plumbing leak
- 📊 Flag: "Unusual electricity usage" - HVAC issue?

**Natural Language Processing:**
- 💬 Analyze chat messages for sentiment
- 😟 Detect: Staff stress or frustration
- 🆘 Identify: Recurring guest complaints
- 📈 Trend: Common questions → Create FAQ

**Automated quality reports:**
- 📝 Generate narrative reports in plain English
- 📊 Highlight key insights without manual analysis
- 💡 Recommend actions based on data
- 📧 Email digestible summaries to owners

---

## 9. BẢO MẬT & QUYỀN RIÊNG TƯ (Security & Privacy)

### 9.1 Data Protection
**User data:**
- 🔐 All data encrypted in transit (TLS 1.3)
- 🔐 All data encrypted at rest (AES-256)
- 🔑 Multi-factor authentication for admins
- 🔒 Role-based access control (RBAC)
- 📝 Audit logs for all data access

**Photo security:**
- 🚫 No public URLs
- ⏱️ Temporary signed URLs (expire in 1 hour)
- 🗑️ Auto-delete after retention period
- 🔍 GPS data not shared with unauthorized users
- 🎭 Face blurring option (guest privacy)

**Compliance:**
- ✅ GDPR compliant (if EU properties)
- ✅ CCPA compliant (if California properties)
- ✅ Data portability (export all user data)
- ✅ Right to deletion (delete account & data)
- 📄 Privacy policy & terms of service

### 9.2 User Authentication
**Login methods:**
- 📧 Email + password
- 📱 Phone + SMS code
- 🔐 Two-factor authentication (2FA)
- 👆 Biometric (fingerprint, face ID)
- 🔑 SSO (Single Sign-On) for enterprise

**Session management:**
- ⏱️ Auto-logout after 8 hours inactive
- 🔄 Refresh tokens for seamless experience
- 🚫 Force logout on password change
- 📱 Manage active sessions (logout from all devices)

**Password requirements:**
- 📏 Minimum 8 characters
- 🔠 Mix of uppercase, lowercase, numbers, symbols
- 🚫 Cannot reuse last 5 passwords
- ⏱️ Expire every 90 days (optional)
- 🔒 Encrypted with bcrypt

### 9.3 Audit Trail
**Track all actions:**

**Logged events:**
- 👤 User login/logout
- 📝 Task created/updated/deleted
- 👥 Staff assigned/reassigned
- ✅ Task status changes
- 📸 Photos uploaded
- 💬 Messages sent (metadata, not content)
- 🔧 System configuration changes
- 📊 Reports generated/exported
- 🚨 Incidents reported/resolved

**Audit log details:**
- ⏰ Timestamp (UTC)
- 👤 User who performed action
- 🎯 Action type
- 📋 Resource affected (task ID, property ID)
- 📝 Before/after values (for updates)
- 🌐 IP address
- 📱 Device info

**Retention:**
- 💾 Keep audit logs for 3 years
- 🔐 Encrypted storage
- 🔍 Searchable by admins only
- 📤 Exportable for compliance audits

---

## 10. KẾT LUẬN & KHUYẾN NGHỊ

### 10.1 MVP Success Metrics
**Measure these to validate MVP:**

1. **Adoption rate:**
   - Target: 90% of staff using app daily within 30 days
   - Track: Daily active users, feature usage

2. **Task completion:**
   - Target: 95% of tasks completed on time
   - Track: On-time %, overdue count, cancellation rate

3. **Quality improvement:**
   - Target: 20% reduction in guest complaints
   - Track: Incident reports, guest feedback scores

4. **Efficiency gains:**
   - Target: 15% reduction in cleaning time per property
   - Track: Average completion time before vs after

5. **Cost savings:**
   - Target: 10% reduction in supply costs
   - Track: Inventory spending, waste reduction

6. **User satisfaction:**
   - Target: 4.0/5.0 staff satisfaction score
   - Track: In-app surveys, feedback submissions

### 10.2 Implementation Phases
**Recommended rollout:**

**Phase 1: Core Cleaning (Weeks 1-4)**
- ✅ User roles & authentication
- ✅ Cleaning schedule import
- ✅ To-Do management
- ✅ Checklists & photo upload
- ✅ Basic reporting
- 🎯 Goal: Replace paper checklists

**Phase 2: Quality & Communication (Weeks 5-8)**
- ✅ AI photo QA
- ✅ In-app chat
- ✅ Incident handling
- ✅ Damage/lost & found logging
- 🎯 Goal: Improve quality & response time

**Phase 3: Maintenance & Inventory (Weeks 9-12)**
- ✅ Maintenance scheduling
- ✅ Inventory management
- ✅ Shortage alerts & auto-tasks
- ✅ Unified calendar
- 🎯 Goal: Complete property operations

**Phase 4: Specialized Services (Weeks 13-16)**
- ✅ Laundry management
- ✅ Lawn & pool care
- ✅ Vendor access & permissions
- ✅ Advanced reporting
- 🎯 Goal: Full-service platform

**Phase 5: Optimization (Weeks 17+)**
- ✅ Analytics & insights
- ✅ Integrations (PMS, accounting)
- ✅ Gamification
- ✅ Mobile app refinements
- 🎯 Goal: Maximize efficiency & adoption

### 10.3 Training Requirements
**For successful adoption:**

**Admin training (4 hours):**
- System overview & navigation
- Schedule import & task creation
- Staff management & assignments
- Incident handling workflows
- Report generation & interpretation
- Vendor management
- System configuration

**Staff training (2 hours):**
- App installation & login
- Viewing & starting tasks
- Checklist completion
- Photo requirements & best practices
- Reporting issues & shortages
- Using chat effectively
- GPS check-in/check-out

**Ongoing support:**
- 📚 Video tutorials library
- 📄 PDF quick reference guides
- 💬 In-app help chat
- 📧 Email support tickets
- 📞 Phone support (business hours)
- 🎓 Monthly refresher webinars

### 10.4 Post-MVP Enhancements
**Future considerations:**

1. **Advanced AI:**
   - Object recognition (count items in photos)
   - Automated inventory counting
   - Predictive failure detection
   - Natural language task creation

2. **IoT Integration:**
   - Smart locks auto-access
   - Sensor-based supply monitoring
   - Automated temperature control
   - Water leak detection sensors

3. **Owner Portal:**
   - Real-time property status
   - Historical reports access
   - Direct communication with staff
   - Maintenance approval workflows

4. **Mobile payment:**
   - Staff tips via app
   - On-the-spot vendor payments
   - Petty cash tracking
   - Expense reimbursements

5. **Enhanced analytics:**
   - Machine learning insights
   - Custom dashboard builder
   - API for third-party integrations
   - Real-time data visualization

### 10.5 Success Checklist
**Before launch:**

- [ ] All user roles configured
- [ ] Sample properties added to system
- [ ] Staff accounts created & tested
- [ ] Schedule import tested with real data
- [ ] Push notifications working on all devices
- [ ] Photo upload & compression tested
- [ ] AI quality check trained & calibrated
- [ ] Reports generating correctly
- [ ] Chat functionality tested
- [ ] GPS accuracy verified
- [ ] Offline mode tested
- [ ] Data backup configured
- [ ] Security audit passed
- [ ] Staff trained on all features
- [ ] Admin guide completed
- [ ] Emergency procedures documented
- [ ] Support contacts established

**Post-launch (First 30 days):**

- [ ] Monitor daily active users
- [ ] Track task completion rates
- [ ] Collect staff feedback
- [ ] Address bugs immediately
- [ ] Adjust AI thresholds based on feedback
- [ ] Optimize notification timing
- [ ] Refine checklists based on usage
- [ ] Document common issues
- [ ] Provide ongoing training
- [ ] Celebrate early wins with team

---

## PHỤ LỤC (Appendices)

### A. Glossary of Terms
- **Par Level:** Mức tồn kho chuẩn cần duy trì
- **SLA:** Service Level Agreement - Cam kết mức độ dịch vụ
- **Check-in/Check-out:** Thời điểm khách đến/rời khỏi property
- **Turnover:** Quy trình dọn dẹp giữa các lượt khách
- **Proof of Work:** Bằng chứng hoàn thành công việc (photos, GPS)
- **Blocking Step:** Bước bắt buộc phải hoàn thành mới tiếp tục
- **Stock-in/Stock-out:** Nhập/xuất vật tư khỏi kho
- **Shortage:** Tình trạng thiếu hụt vật tư
- **Incident:** Sự cố cần xử lý khẩn cấp
- **Escalation:** Nâng mức độ ưu tiên khi không được xử lý kịp thời

### B. Sample Checklists
**(Đã mô tả chi tiết trong Section A.4)**

### C. Photo Requirements Guide
**(Đã mô tả chi tiết trong Section A.7)**

### D. Emergency Procedures
**(Đã mô tả chi tiết trong Section 7.2)**

### E. Contact Information
**For technical support:**
- 📧 Email: support@aristay.com
- 📞 Phone: [Support Hotline]
- 💬 In-app chat: Available 24/7
- 🌐 Knowledge base: help.aristay.com

**For emergencies:**
- 🚨 Emergency hotline: [Number]
- 📱 On-call manager: [Contact]
- 🏥 First aid: Dial 911 (US) / Local emergency number

---

# END OF DOCUMENT

**Document Version:** 1.0  
**Last Updated:** [Current Date]  
**Next Review:** [30 days from creation]  
**Owner:** Product Manager, AriStay  
**Status:** Ready for Development