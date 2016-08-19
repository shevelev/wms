-- =============================================
-- �����:		��������� ��������
-- ������:		������, �.�������
-- ���� ��������: 05.03.2010 (������)
-- ��������: ����� ����� � ������ BRAKPRIEM
--	...
-- =============================================
ALTER PROCEDURE [rep].[Product_in_cell] ( 
									
	@wh varchar(30)
)

as




select  lotx.storerkey Storer,
		st.company Company,
		lotx.sku Sku,
		sk.descr Descr,
		lotx.lot Lot,
		lotx.qty Qty,
		lotx.adddate DatePriem		
from WH1.LOTXLOCXID lotx
left join WH1.sku sk on lotx.storerkey=sk.storerkey and lotx.sku=sk.sku
left join WH1.STORER st on lotx.storerkey=st.storerkey
where  lotx.loc='BRAKPRIEM'
		and lotx.qty>0



