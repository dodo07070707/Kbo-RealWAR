const axios = require('axios');
const Excel = require('exceljs')
async function ExcelTest(){
    //엑셀 워크북 생성 및 시트 생성
    const workbook = new Excel.Workbook();
    const worksheet = workbook.addWorksheet("My Sheet");
  
    //대표행(타이틀행) 설정 및 입력
  worksheet.columns = [
    {header: '종류', key: 'type', width: 10},
    {header: '연도', key: 'year', width: 10},
    {header: '순위', key: 'rank', width: 10},
    {header: '이름', key: 'name', width: 10},
    {header: '팀', key: 'team', width: 10},
    {header: 'WAR', key: 'war', width: 35}, 
    {header: 'G', key: 'g', width: 15}, 
    {header: 'PA', key: 'pa', width: 15}, 
    {header: 'ePA', key: 'epa', width: 15}, 
    {header: 'AB', key: 'ab', width: 15}, 
    {header: 'R', key: 'r', width: 15}, 
    {header: 'H', key: 'h', width: 15}, 
    {header: '2B', key: '2b', width: 15}, 
    {header: '3B', key: '3b', width: 15}, 
    {header: 'HR', key: 'hr', width: 15}, 
    {header: 'TB', key: 'tb', width: 15}, 
    {header: 'RBI', key: 'rbi', width: 15}, 
    {header: 'SB', key: 'sb', width: 15}, 
    {header: 'CS', key: 'cs', width: 15}, 
    {header: 'BB', key: 'bb', width: 15}, 
    {header: 'HP', key: 'hp', width: 15}, 
    {header: 'IB', key: 'ib', width: 15}, 
    {header: 'SO', key: 'so', width: 15}, 
    {header: 'GDP', key: 'gdp', width: 15}, 
    {header: 'SH', key: 'sh', width: 15}, 
    {header: 'SF', key: 'sf', width: 15},
  ];
  
  
  for(let a = 0; a < 2; a ++) {
    
  for(let year = 2024; year < 2025; year ++) {
    const result = await axios.get(`https://statiz.sporki.com/stats/?m=main&m2=${ a == 0 ? 'batting' : 'pitching' }&m3=default&so=&ob=&year=${ year }&sy=&ey=&te=&po=&lt=10100&reg=A&pe=&ds=&de=&we=&hr=&ha=&ct=&st=&vp=&bo=&pt=&pp=&ii=&vc=&um=&oo=&rr=&sc=&bc=&ba=&li=&as=&ae=&pl=&gc=&lr=&pr=1000&ph=&hs=&us=&na=&ls=0&sf1=G&sk1=&sv1=&sf2=G&sk2=&sv2=`)
    let cnt = 0;
    let type = 'th'
    const trs = result.data.split('<tr>').map(_data => _data.split('</tr>')[0]).filter(_tr => _tr.includes('<th') == false).filter(_tr => _tr.includes('<td') == true).filter(_tr => typeof _tr == 'string')
    for(const _index in trs) {
        cnt ++

        worksheet.addRow({year: year, rank: cnt,
            type: a == 0 ? '타격' : '투구',
            team: trs[_index].split('class="teams"')[1].split('>')[1].split('background:')[1].split(';')[0],
            war: trs[_index].split('<td')[4].split('>')[1].split('<')[0],
            name: trs[_index].split('playerinfo')[1].split('>')[1].split('<')[0],
            g: trs[_index].split('<td')[5].split('>')[1].split('<')[0],
            pa: trs[_index].split('<td')[6].split('>')[1].split('<')[0],
            epa: trs[_index].split('<td')[7].split('>')[1].split('<')[0],
            ab: trs[_index].split('<td')[8].split('>')[1].split('<')[0],
            r: trs[_index].split('<td')[9].split('>')[1].split('<')[0],
            h: trs[_index].split('<td')[10].split('>')[1].split('<')[0],
            '2b': trs[_index].split('<td')[11].split('>')[1].split('<')[0],
            '3b': trs[_index].split('<td')[12].split('>')[1].split('<')[0],
            hr: trs[_index].split('<td')[13].split('>')[1].split('<')[0],
            tb: trs[_index].split('<td')[14].split('>')[1].split('<')[0],
            rbi: trs[_index].split('<td')[15].split('>')[1].split('<')[0],
            sb: trs[_index].split('<td')[16].split('>')[1].split('<')[0],
            cs: trs[_index].split('<td')[17].split('>')[1].split('<')[0],
            bb: trs[_index].split('<td')[18].split('>')[1].split('<')[0],
            hp: trs[_index].split('<td')[19].split('>')[1].split('<')[0],
            ib: trs[_index].split('<td')[20].split('>')[1].split('<')[0],
            so: trs[_index].split('<td')[21].split('>')[1].split('<')[0],
            gdp: trs[_index].split('<td')[22].split('>')[1].split('<')[0],
            sh: trs[_index].split('<td')[23].split('>')[1].split('<')[0],
            sf: trs[_index].split('<td')[24].split('>')[1].split('<')[0],
        })
    }
}
  }
  await workbook.xlsx.writeFile('export.xlsx');
  
  };
  
  ExcelTest().then(console.log('finish'))