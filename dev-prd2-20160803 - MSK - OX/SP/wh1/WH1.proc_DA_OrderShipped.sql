

-- ������ �������� ������

ALTER PROCEDURE [WH1].[proc_DA_OrderShipped](
	@wh varchar(10),
	@transmitlogkey varchar (10)
)AS

------------declare	@orderkey varchar (10) -- ����� ������

------------select @orderkey = tl.key1 from wh1.transmitlog tl 
------------where tl.transmitlogkey = @transmitlogkey


declare	@orderkey varchar (10) -- ����� ������
declare	@key2 varchar (10)     -- ����� ������ ������
declare @linecnt  int
declare @linecnt2 int

create TABLE #result 
(	
	[storerkey] varchar(15),
	[externorderkey] varchar(32),
	[type] varchar(10),
	[susr1] varchar(30),
	[susr2] varchar(30),
	[susr3] varchar(30),
	[consigneekey] varchar(10),
	[b_company] varchar(10),
	[carriercode] varchar(10),
	[sku] varchar(10),
	[shippedqty] varchar(30)
)

select	@orderkey = o.orderkey, @key2 = tl.key2 
from	wh1.orders o, wh1.transmitlog tl 
where	tl.transmitlogkey = @transmitlogkey 
	and o.orderkey = tl.key1

-- ���� �� ��� ������ ������ ���������, ��� ��������� ��� ���������� � ����-�������, �� �� ��������� ����

-- pickdetail.status = ''6'' ����������� ������ ������
-- pickdetail.status = ''9'' ����������� ������ ������

-- pickdetail.pdudf2 = ''6'' ������� ������ ���������� � HOST ������� ����� ��������
-- pickdetail.pdudf2 = ''9'' ������� ������ ���������� � HOST ������� ����� ��������

select @linecnt  = count(*) from wh1.pickdetail where orderkey = @orderkey
select @linecnt2 = count(*) from wh1.pickdetail where orderkey = @orderkey and 
					[status]='9' and (isnull(pdudf2,'')='' or pdudf2='6')

if @linecnt = @linecnt2
begin
	--�������� ����� ��� ������ � ���
	exec dbo.DA_GetNewKey 'wh1','eventlogkey',@transmitlogkey output
	
	--�������� � ��� ������� �� �������� ������
	insert wh1.transmitlog (whseid, transmitlogkey, tablename, key1,ADDWHO) 
	values ('WH1', @transmitlogkey, 'ordershippedda', @orderkey, 'dataadapter')

	-- ��������� ������ � �������� � ����-�������
	update wh1.pickdetail set pdudf2 = isnull(pdudf2,'')+ '9' where orderkey = @orderkey
end


select 'RETURNSHIPMENTORDER' filetype, STORERKEY, ORDERKEY,EXTERNORDERKEY from wh1.ORDERS where ORDERKEY = @orderkey --and type = '26'

--drop table #result
--drop table #tmp
--drop table #result1


----status pickdetail
----	0 - ��������������
----	1 - �������
----	5 - �������
----	6 - ��������
----	8 - ��������
----	9 - ��������

----
----
----


